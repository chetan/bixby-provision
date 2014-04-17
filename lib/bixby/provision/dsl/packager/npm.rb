
module Bixby
  module Provision
    module Packager

      class NPM < Base

        def install(*packages)
          if packages.last.kind_of? Hash then
            opts = packages.pop
          else
            opts = {}
          end
          packages = packages.flatten.sort

          logger.info "npm install: " + packages.join(" ")

          installed = query_installed_packages(packages, opts)
          needed = packages.find_all{ |s| !installed.include? s }
          if needed.empty? then
            logger.info "[npm] package(s) already installed"
            return
          end

          global = opts[:global]
          if global then
            cmd = "npm install -g " + packages.join(" ")
            logged_sudo(cmd, env)
          else
            cmd = "npm install " + packages.join(" ")
            logged_systemu(cmd, env)
          end
        end

        def installed?(package, opts={})
          query_installed_packages(package, opts).include? package
        end

        private


        # Query NPM DB for presence of given packages. Returns a hash for easy lookup
        #
        # @param [Array<String>] packages
        #
        # @return [Hash<String, 1>]
        def query_installed_packages(packages, opts={})
          packages = [ packages ] if not packages.kind_of? Array
          packages.flatten!

          g = opts[:global] ? "-g" : ""

          installed = {}
          systemu("npm #{g} ls --parseable --depth 1 " + packages.join(" "), env).
            stdout.split(/\n/).each{ |s| installed[File.basename(s)] = 1 }

          return installed
        end

        def env
          { :env => { "PATH" => Provision::Base::PATH } }
        end
      end

    end
  end
end
