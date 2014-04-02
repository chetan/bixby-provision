
module Bixby
  module Provision

    class Ruby

      EXPORTS = [:gem]

      def install(opts={})
        puts "installing ruby"
      end

      def gem(name, opts={})
      end

    end

    register_dsl Ruby

  end
end
