
module Bixby
  module Provision

    class Base

      include Bixby::Log
      include Bixby::ScriptUtil

      def tap(&block)
        self.instance_eval(&block)
      end

    end

  end
end
