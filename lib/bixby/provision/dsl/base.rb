
module Bixby
  module Provision

    class Base

      include Bixby::Log
      include Bixby::ScriptUtil

      def tap(&block)
        self.instance_eval(&block)
      end

      def logged_sudo(*args)
        cmd = sudo(*args)
        logger.info {
          s = cmd.command
          s += "\nSTATUS: #{cmd.exitstatus}" if !cmd.success?
          s += "\nSTDOUT:\n#{cmd.stdout}" if !cmd.stdout.strip.empty?
          s += "\nSTDERR:\n#{cmd.stderr}" if !cmd.stderr.strip.empty?
          s
        }
        cmd
      end

    end

  end
end
