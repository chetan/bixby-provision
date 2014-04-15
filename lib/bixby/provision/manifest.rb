
require "bixby/provision/manifest/dsl_proxy"

module Bixby
  module Provision

    class Manifest

      def initialize(filename)
        @filename = filename
        load_manifest(filename)
      end

      def load_manifest(filename)
        dsl = DSLProxy.new
        dsl.instance_eval(File.read(filename), filename, 1)
      end

    end

  end
end
