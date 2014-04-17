
require "bixby/provision/dsl/services/base"
require "bixby/provision/dsl/services/init"

module Bixby
  module Provision

    class Service < Base

      def initialize(*args)
        super
        @services = if ubuntu? then
            Services::Init.new
          elsif centos? or amazon? then
            Services::Init.new
          end
      end

      def start(name, opts={})
        if !running?(name) || opts[:force] == true then
          @services.start(name, opts)
        end
      end

      def stop(name, opts={})
        if running?(name) || opts[:force] == true then
          @services.stop(name, opts)
        end
      end

      def restart(name, opts={})
        @services.restart(name, opts)
      end

      def reload(name, opts={})
        @services.reload(name, opts)
      end

      def running?(name)
        @services.running?(name)
      end

    end

    register_dsl Service

  end
end
