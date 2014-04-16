
module Bixby
  module Provision

    class Bundler < Base

      EXPORTS = []

      def install(opts={})
        logger.info "bundle.install"
      end

    end

    register_dsl Bundler, "bundle"

  end
end
