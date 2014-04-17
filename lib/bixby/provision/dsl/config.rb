
require "tilt"

module Bixby
  module Provision

    class Config < Base

      EXPORTS = []

      def file(dest, opts={})

        dest_file = File.expand_path(dest)
        dir.create(File.dirname(dest_file))

        source = resolve_file(opts.delete(:source))
        if source.nil? then
          # TODO raise
        end

        template = get_template(source)
        if template.nil? then
          # just copy the file over
          if File.writable?(dest_file) then
            logger.info "copying #{source} to #{dest}"
            FileUtils.cp(source, dest_file)
          else
            logger.info "copying #{source} to #{dest} (as root)"
            logged_sudo("cp #{source} #{dest_file}")
          end

        else
          # use template
          logger.info "rendering template #{source}"
          str = template.render(self.proxy)
          # TODO use sudo+cp from temp if necessary
          File.open(dest_file, 'w') do |f|
            f.write str
          end
        end

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

      def resolve_file(file)
        return nil if file.nil?

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
