
module Bixby
  module Provision
    module Packager

      class Base

        include Bixby::Log
        include Bixby::ScriptUtil

        attr_reader :manifest

        def initialize(manifest)
          @manifest = manifest
        end

      end

    end
  end
end
