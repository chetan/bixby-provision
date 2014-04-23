
module Bixby
  module Provision

    class FileDSL < Base

      EXPORTS = [:symlink]

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

    end

    register_dsl FileDSL, "file"

  end
end
