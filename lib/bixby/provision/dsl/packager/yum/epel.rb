
module Bixby
  module Provision
    module Packager
      class Yum < Base

        module EPEL

          private

          def install_epel(opts)

            if amazon? then
              return install_epel_amazon(opts)
            end

            if installed? "epel-release" then
              logger.info "epel repo already installed"
              return false
            end

            logger.info "installing epel repo"

            url = if centos_version >= SemVer.parse("v6.0.0") && centos_version < SemVer.parse("v7.0.0") then
                "http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm"
              elsif centos_version >= SemVer.parse("v5.0.0") && centos_version < SemVer.parse("v6.0.0") then
                "http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm"
              end

            Dir.mktmpdir("bixby-provision") do |dir|
              Dir.chdir(dir) do
                logged_sudo("rpm --quiet -iv #{url}")
              end
            end

            true
          end

          def install_epel_amazon(opts)
            logger.info "enabling epel on amazon linux"

            file = "/etc/yum.repos.d/epel.repo"

            buff = File.read(file)
            out = []
            found = false
            buff.split(/\n/).each do |line|
              if line =~ /^enabled=/ then
                # always enable the first entry only (leave debug and source repos, for now)
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

        end # EPEL

        Yum.register_plugin(EPEL)

      end
    end
  end
end
