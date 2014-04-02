
module Bixby
  module Provision

    class SCM

      EXPORTS = [:checkout]

      def checkout(uri, opts={})
      end

    end

    register_dsl SCM

  end
end
