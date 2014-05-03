
module Bixby
  module Provision
    module Packager

      class Yum < PackagerBase

        YUM_REPOS_D = "/etc/yum.repos.d/"

        REPOS = {}

        def self.register_plugin(mod, method=nil, name=nil)
          if name.nil? then
            name = mod.name.split(/::/).last.downcase
          end
          if method.nil? then
            method = "install_#{name}".to_sym
          end
          logger.debug "[yum] registered plugin: #{name}"
          REPOS[name] = method
          include(mod)
        end

        def refresh
          sudo("yum -q clean all")
          sudo("yum -q -y check-update")
        end

        def upgrade_system
          logged_sudo('yum -q -y upgrade')
        end

        def install_repo(name, opts={})
          name.downcase!
          if REPOS.include? name then
            return self.send(REPOS[name], opts)
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

          dest = File.join(YUM_REPOS_D, File.basename(url))
          if File.exists? dest then
            logger.debug "repo already exists"
            return false
          end

          self.proxy.sys.package "wget"

          t = tempfile(true)
          if logged_systemu("wget -q #{url} -O #{t.path}").fail? then
            # TODO raise
          end

          logged_sudo("mv -f #{t.path} #{dest}").success?
        end

      end # Yum

    end
  end
end

require "bixby/provision/dsl/packager/yum/epel"
require "bixby/provision/dsl/packager/yum/mongodb"
