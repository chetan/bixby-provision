
require "bixby/provision/manifest/dsl_proxy"

module Bixby
  module Provision

    class Manifest

      attr_reader :filename, :digest

      def initialize(filename)
        @filename = filename
        @digest = Digest::SHA2.new(256).file(filename).hexdigest()
        load_manifest(filename)
      end

      def load_manifest(filename)
        dsl = DSLProxy.new(self)
        dsl.instance_eval(File.read(filename), filename, 1)
      end

    end

  end
end
