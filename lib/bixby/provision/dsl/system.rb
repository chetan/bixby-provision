
module Bixby
  module Provision

    class System < Base

      EXPORTS = [:refresh_packages, :upgrade_system, :package]

      def refresh_packages
        if ubuntu? then
          logger.info "refresh_packages via apt"
          sudo("apt-get -qqy update")

        elsif centos? or amazon? then
          logger.info "refresh_packages via yum"
          sudo("yum -q clean all")
          sudo("yum -q -y check-update")

        end
      end

      def upgrade_system
        if ubuntu? then
          logger.info "upgrade_system via apt"
          env = { "DEBIAN_FRONTEND" => "noninteractive" }
          logged_sudo('DEBIAN_FRONTEND=noninteractive dpkg-reconfigure grub-pc', :env => env)
          logged_sudo('apt-get -qqy -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade', :env => env)
          logged_sudo('apt-get -qqy autoremove')
          logged_sudo('apt-get -qqy autoclean')

        elsif centos? or amazon? then
          logger.info "upgrade_system via yum"
          logged_sudo('yum -q -y upgrade')

        end
      end

      def package(*args)
      end

    end

    register_dsl System, "sys"

  end
end
