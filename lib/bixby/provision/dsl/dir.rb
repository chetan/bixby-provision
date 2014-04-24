
module Bixby
  module Provision

    class DirDSL < Base

      EXPORTS = [:mkdir, :mkdir_p]

      def create(path, opts={})
        logger.info "[dir] ensuring #{path} exists"
        begin
          FileUtils.mkdir_p(path) if !File.exists? path
          chown(path, opts[:chown])
          chmod(path, opts[:chmod])
        rescue Errno::EACCES => ex
          logger.info "[dir] permission denied, trying again with sudo"
          logged_sudo("mkdir -p #{path}")
          chown(path, opts[:chown])
          chmod(path, opts[:chmod])
        end
      end
      alias_method :mkdir, :create
      alias_method :mkdir_p, :create

      def recreate(path, opts={})
      end

    end

    register_dsl DirDSL, "dir"

  end
end
