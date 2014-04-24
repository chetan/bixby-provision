
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

        if File.writable? dest_dir then
          dest = args.size > 1 ? dest_dir : dest
          logged_systemu("cp #{args.join(' ')} #{dest}")

        else
          # as root
          dest = args.size > 1 ? dest_dir : dest
          logged_sudo("cp #{args.join(' ')} #{dest}")
        end

      end

    end

    register_dsl FileDSL, "file"

  end
end
