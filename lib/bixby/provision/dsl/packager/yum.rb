
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

        def install_repo(name, opts={})
          name.downcase!
          if name == "epel" then
            return install_epel_amazon() if amazon?
            return install_epel()
          end
        end


        private

        def install_epel(opts={})
          false
        end

        def install_epel_amazon(opts={})
          file = "/etc/yum.repos.d/epel.repo"

          buff = File.read(file)
          out = []
          found = false
          buff.split(/\n/).each do |line|
            if line == "enabled=0" && found == false then
              found = true
              out << "enabled=1"
            else
              out << line
            end
          end

          File.open(file, 'w') do |f|
            f.puts out.join("\n")
          end

          true
        end

      end

    end
  end
end
