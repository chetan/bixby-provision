
module Bixby
  module Provision

    class FileDSL < Base

      EXPORTS = [:symlink, :copy, :cp]

      def create(opts={})
      end

      def symlink(source, dest)
        source = File.expand_path(source)
        dest   = File.expand_path(dest)

        if File.symlink?(dest) && File.realpath(dest) == source then
          logger.info "[file] #{dest} already points to #{source}"
          return
        end

        logger.info "[file] creating symlink: #{dest} -> #{source}"

        if File.writable? File.dirname(dest) then
          FileUtils.symlink(source, dest)
        else
          # as root
          logged_sudo("ln -sf #{source} #{dest}")
        end
      end

      def copy(*args)
        if args.last.kind_of? Hash then
          opts = args.pop
        else
          opts = {}
        end

        dest = File.expand_path(args.pop)
        if args.length > 1 || args.first.include?("*") then
          dest_dir = dest
          self.dir.mkdir(dest_dir)
        elsif File.directory? dest then
          dest_dir = dest
        else
          dest_dir = File.dirname(dest)
          self.dir.mkdir(dest_dir)
        end

        args = args.map{ |s| File.expand_path(s) }
        files = args.join(' ')

        if File.writable? dest_dir then
          dest = args.size > 1 ? dest_dir : dest
          logger.info "[file] copying #{files} -> #{dest}"
          logged_systemu("cp #{files} #{dest}")

        else
          # as root
          dest = args.size > 1 ? dest_dir : dest
          logger.info "[file] copying #{files} -> #{dest}"
          logged_sudo("cp #{files} #{dest}")
        end


        return if !(opts[:chmod] or opts[:chown])

        # need to take care to translate src args to dest path
        # can't simply pass args into chmod/chown for this reason,
        # since we want to affect the newly copied files

        if args.length > 1 || args.first.include?("*") then
          # work on all source files
          args.each do |s|
            if s.include? "*" then
              Dir.glob(s).each{ |e|
                f = File.join(dest_dir, File.basename(e))
                chmod(f, opts[:chmod]) if opts[:chmod]
                chown(f, opts[:chown]) if opts[:chown]
              }
            else
              f = File.join(dest_dir, File.basename(e))
              chmod(f, opts[:chmod]) if opts[:chmod]
              chown(f, opts[:chown]) if opts[:chown]
            end
          end

        else
          # work on a single file
          if File.directory? dest then
            dest = File.join(dest, File.basename(args.first))
          end

          chmod(dest, opts[:chmod]) if opts[:chmod]
          chown(dest, opts[:chown]) if opts[:chown]
        end

      end # copy

    end

    register_dsl FileDSL, "file"

  end
end
