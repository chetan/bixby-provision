
require "bixby/provision/manifest/dsl_proxy"

module Bixby
  module Provision

    class Manifest

      def initialize(filename)
        @filename = filename
        @digest = Digest::SHA2.new(256).file(filename).hexdigest()
        load_manifest(filename)
      end

      def load_manifest(filename)
        dsl = DSLProxy.new
        dsl.instance_eval(File.read(filename), filename, 1)
      end

    end

  end
end
