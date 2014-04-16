
module Bixby
  module Provision
    module Packager

      class Yum < Base

        YUM_REPOS_D = "/etc/yum.repos.d/"

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
            return install_epel_amazon(opts) if amazon?
            return install_epel(opts)
          elsif name =~ /^https?.*\.repo$/ then
            return install_repo_url(name, opts)
          end
        end

        def install(*packages)
          packages.flatten!

          # only install missing packages
          installed = query_installed_packages(packages)
          needed = packages.find_all{ |s| !installed.include? s }
          return if needed.empty?

          logged_sudo("yum -q -y install " + needed.join(" "))
        end

        def installed?(package)
          query_installed_packages(package).include? package
        end

        private

        # Query RPM DB for presence of given packages. Returns a hash for easy lookup
        #
        # @param [Array<String>] packages
        #
        # @return [Hash<String, 1>]
        def query_installed_packages(packages)
          packages = [ packages ] if not packages.kind_of? Array
          packages.flatten!

          installed = {}
          systemu("rpm -qa --queryformat '%{NAME}\n' " + packages.join(" ")).
            stdout.split(/\n/).each{ |s| installed[s] = 1 }

          return installed
        end

        def install_repo_url(url, opts)
          logger.info "installing repo from #{url}"

          if File.exists? File.join(YUM_REPOS_D, File.basename(url)) then
            logger.debug "repo already exists"
            return false
          end

          self.proxy.sys.package "wget"

          if systemu("wget -q #{url}", :cwd => YUM_REPOS_D).fail? then
            # TODO raise
          end

          true
        end

        def install_epel(opts)

          if installed? "epel-release" then
            logger.info "epel repo already installed"
            return false
          end

          logger.info "installing epel repo"

          url = if centos_version >= SemVer.parse("v6.0.0") && centos_version < SemVer.parse("v7.0.0") then
              "http://mirror.metrocast.net/fedora/epel/6/i386/epel-release-6-8.noarch.rpm"
            elsif centos_version >= SemVer.parse("v5.0.0") && centos_version < SemVer.parse("v6.0.0") then
              "http://mirror.metrocast.net/fedora/epel/5/i386/epel-release-5-4.noarch.rpm"
            end

          Dir.mktmpdir("bixby-provision") do |dir|
            Dir.chdir(dir) do
              if systemu("wget -q #{url}").fail? then
                # TODO raise
              end

              logged_sudo("rpm --quiet -iv " + File.basename(url))
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

      end

    end
  end
end
