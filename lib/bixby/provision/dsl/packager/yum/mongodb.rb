
module Bixby
  module Provision
    module Packager
      class Yum < PackagerBase

        module MongoDB

          private

          def install_mongodb(opts)

            file = File.join(YUM_REPOS_D, "mongodb.repo")
            if File.exists?(file) then
              logger.info "[yum] mongodb repo already installed"
              return
            end

            logger.info "[yum] installing mongodb repo"

            arch = amd64?() ? "x86_64" : "i686"

            File.open(file, 'w') do |f|
              f.puts <<-EOF
[mongodb]
name=MongoDB Repository
baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/#{arch}/
gpgcheck=0
enabled=1
EOF
            end

            true
          end

        end # MongoDB

        Yum.register_plugin(MongoDB)

      end
    end
  end
end
