
module Bixby
  module Provision

    class Base
      def tap(&block)
        self.instance_eval(&block)
      end
    end

  end
end
