
module Bixby
  module Provision
    module Packager

      class Apt < Base

        def refresh
          sudo("apt-get -qqy update")
        end

        def upgrade_system
          logged_sudo('DEBIAN_FRONTEND=noninteractive dpkg-reconfigure grub-pc', :env => env)
          logged_sudo('apt-get -qqy -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade', :env => env)
          logged_sudo('apt-get -qqy autoremove')
          logged_sudo('apt-get -qqy autoclean')
        end

        def install(*packages)
          packages.flatten!
          logged_sudo("apt-get -qqy install " + packages.join(" "))
        end


        private

        def env
          { "DEBIAN_FRONTEND" => "noninteractive" }
        end

      end

    end
  end
end
