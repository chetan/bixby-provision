
require "tilt"

module Bixby
  module Provision

    class Config < Base

      EXPORTS = []

      def file(dest, opts={})

        # By default, attempt to preserve ownership and mode if none are given in opts
        opts[:preserve] = true if !opts.include? :preserve

        dest_file = File.expand_path(dest)
        if File.exists? dest_file then
          stat = File.stat(dest_file)
          old_owner = "#{stat.uid}:#{stat.gid}"
          old_mode  = stat.mode
        else
          old_owner = old_mode = nil
          dir.create(File.dirname(dest_file))
        end

        source = resolve_file(opts.delete(:source), dest_file)
        if source.nil? then
          # TODO raise
        end

        template = get_template(source)
        if template.nil? then

          if sha256sum(dest_file) == sha256sum(source) then
            logger.info "[config] skipping #{dest_file}: sha256sum matches"
            return
          end

          # just copy the file over
          if File.writable?(dest_file) then
            logger.info "[config] copying #{source} to #{dest}"
            FileUtils.cp(source, dest_file)
          else
            logger.info "[config] copying #{source} to #{dest} (as root)"
            logged_sudo("cp #{source} #{dest_file}")
          end

        else
          # use template
          logger.info "[config] rendering template #{source}"
          str = template.render(self.proxy)

          if (File.exists? dest_file and File.writable? dest_file) or
              File.writable? File.dirname(dest_file) then

            # write directly
            File.open(dest_file, 'w') { |f| f.write str }

          else
            # write to temp and mv into place
            t = Tempfile.new("bixby-provision-")
            t.write str
            t.close
            logged_sudo("mv #{t.path} #{dest_file}")
          end

        end

        # set correct ownership/mode
        owner = opts[:chown]
        mode = opts[:chmod]
        if opts[:preserve] then
          owner ||= old_owner
          mode ||= old_mode
        end
        chown(dest_file, owner)
        chmod(dest_file, mode)

      end


      private

      def get_template(file)
        return nil if File.basename(file) !~ /\..*$/
        begin
          return Tilt.new(file)
        rescue RuntimeError => ex
          if ex.message =~ /No template engine registered/ then
            return nil
          end
          raise ex
        end
        nil
      end

      def resolve_file(file, dest)
        if file.nil? then
          return nil if dest.nil?
          # look for a file with the same name as in dest
          file = File.basename(dest)
        end

        f = File.expand_path(file)
        return f if File.exists? f

        # search for it in file/
        f = File.expand_path("../files/#{file}", self.manifest.filename)
        return f if File.exists? f

        # look for the given file with any extension
        files = Dir.glob("#{f}.*")
        return files.shift if files.size == 1

        return nil
      end


    end

    register_dsl Config

  end
end
