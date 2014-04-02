
require "bixby/provision/manifest/dsl"

module Bixby
  module Provision

    class Manifest

      def initialize(file)
        @file = file
        load_manifest(file)
      end

      def load_manifest(file)
        dsl = DSL.new
        dsl.instance_eval(File.read(file), file, 1)
      end

    end

  end
end
