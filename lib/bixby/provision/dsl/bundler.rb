
module Bixby
  module Provision

    class Bundler

      EXPORTS = [:install]

      def install(opts={})
        puts "installing bundle"
      end

    end

    register_dsl Bundler, "bundle"

  end
end
