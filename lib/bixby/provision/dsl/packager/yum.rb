
module Bixby
  module Provision
    module Packager

      class Yum < Base

        def refresh
          sudo("yum -q clean all")
          sudo("yum -q -y check-update")
        end

        def upgrade_system
          logged_sudo('yum -q -y upgrade')
        end

      end

    end
  end
end
