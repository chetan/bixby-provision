
module Bixby
  module Provision
    class SCM < Base

      class SCMBase

        include Bixby::Log
        include Bixby::ScriptUtil

        attr_reader :uri

        def initialize(uri)
          @uri = uri
        end

      end

    end
  end
end
