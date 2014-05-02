
require "bixby/provision/manifest/dsl_proxy"

module Bixby
  module Provision

    class Manifest

      include Bixby::Log

      attr_reader :filename, :digest

      def initialize(filename)
        test_sudo_access()
        @filename = filename
        @digest = Digest::SHA2.new(256).file(filename).hexdigest()
        load_manifest(filename)
      end

      def load_manifest(filename)
        dsl = DSLProxy.new(self)
        str = File.read(filename)
        logger.debug { sprintf("read %s line(s)", str.split(/\n/).size) }
        dsl.instance_eval(str, filename, 1)
      end

      private

      def test_sudo_access
        if Process.pid == 0 then
          sudo = ENV["SUDO_USER"]
          logger.debug "running as root" + (sudo ? " (via sudo user #{sudo})" : "")
          return
        end

        cmd = Mixlib::ShellOut.new("sudo -n whoami")
        cmd.run_command
        if cmd.success? then
          logger.debug "running as #{ENV['USER']} with sudo access"
        else
          STDERR.ptus "running as #{ENV['USER']} but sudo command failed: #{cmd.stdout}"
          exit 1
        end
      end

    end

  end
end
