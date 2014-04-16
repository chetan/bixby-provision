
module Bixby
  module Provision
    class Manifest

      class DSLProxy
        extend Forwardable
        attr_reader :manifest

        def initialize(manifest)
          @manifest = manifest
        end
      end

    end
  end
end
