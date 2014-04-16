
module Bixby
  module Provision

    class Variable < Base

      EXPORTS = [:set, :get]

      def initialize(*args)
        super
        @variables = {}
      end

      def set(name, value)
        @variables[name] = value
      end

      def get(name)
        @variables[name]
      end

    end

    register_dsl Variable

  end
end
