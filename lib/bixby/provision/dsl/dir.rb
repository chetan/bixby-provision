
module Bixby
  module Provision

    class DirDSL

      EXPORTS = []

      def create(path, opts={})
      end

      def recreate(path, opts={})
      end

    end

    register_dsl DirDSL, "dir"

  end
end
