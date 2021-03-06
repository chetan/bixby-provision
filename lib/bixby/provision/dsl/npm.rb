
module Bixby
  module Provision

    class NPM < Base

      EXPORTS = []

      def install(*packages)
        Packager::NPM.new(self).install(*packages)
      end

    end

    register_dsl NPM

  end
end
