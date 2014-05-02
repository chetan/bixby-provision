
require "bixby/provision/dsl/packager/base"
require "bixby/provision/dsl/packager/apt"
require "bixby/provision/dsl/packager/yum"
require "bixby/provision/dsl/packager/npm"

module Bixby
  module Provision

    class System < Base

      EXPORTS = [:refresh_packages, :upgrade_system, :package, :repo]

      attr_reader :packager

      def initialize(*args)
        super
        @packager = if ubuntu? then
          Packager::Apt.new(self)
        elsif centos? or amazon? then
          Packager::Yum.new(self)
        end
      end

      def refresh_packages
        logger.info "[sys] refresh_packages"
        packager.refresh
      end

      def upgrade_system
        logger.info "[sys] upgrade_system"
        packager.upgrade_system
      end

      def package(*packages)
        packages.flatten!
        logger.info "[sys] installing packages: " + packages.join(" ")
        packager.install(*packages)
      end
      alias_method :packages, :package

      def repo(name, opts={})
        if packager.install_repo(name, opts) then
          refresh_packages
        end
      end

    end

    register_dsl System, "sys"

  end
end
