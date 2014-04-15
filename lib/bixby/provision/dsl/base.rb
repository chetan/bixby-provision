
module Bixby
  module Provision

    class Base

      include Bixby::Log
      include Bixby::ScriptUtil

      PATH = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

      attr_accessor :manifest

      def tap(&block)
        self.instance_eval(&block)
      end

    end

  end
end
