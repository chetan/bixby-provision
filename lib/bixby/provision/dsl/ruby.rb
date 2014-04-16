
module Bixby
  module Provision

    class Ruby < Base

      EXPORTS = [:gem]

      def install(opts={})
        logger.info "ruby.install"
      end

      def gem(name, opts={})
      end

    end

    register_dsl Ruby

  end
end
