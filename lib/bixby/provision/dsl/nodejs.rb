
module Bixby
  module Provision

    class NodeJS < Base

      EXPORTS = [:npm]

      CURRENT_VERSION = "0.10.26"

      def install(opts={})
        logger.info "nodejs.install"

        version = opts.delete(:version) || CURRENT_VERSION
        path = opts.delete(:path) || "/usr/local"

        if ubuntu? then
          install_from_tarball(version, path)
        elsif amazon? or centos? then
          sys.package "nodejs"
        end

      end

      def npm(name, opts={})
      end


      private

      def install_from_tarball(version, path)

        version = "v" + version if version !~ /^v/

        bin = File.join(path, "bin", "node")
        if File.exists?(bin) then
          installed_ver = systemu("#{bin} --version").stdout.strip
          if SemVer.parse(installed_ver) == SemVer.parse(version) then
            logger.info "nodejs #{version} is already installed at #{path}"
            return
          elsif SemVer.parse(installed_ver) > SemVer.parse(version) then
            logger.info "a newer nodejs (#{version}) is already installed at #{path}"
            return
          else
            logger.info "nodejs #{installed_ver} is currently installed; upgrading to #{version}"
          end
        end

        url = package_url(version)
        Dir.mktmpdir("bixby-provision") do |dir|
          Dir.chdir(dir) do
            # download
            logger.info "downloading #{url}"
            systemu("wget -nv #{url}")

            # install
            file = File.basename(url)
            logger.info "installing node-#{version}"
            systemu("tar -xzf #{file}")
            systemu("rm -f *.gz")
            systemu("cd node* && sudo cp -a bin lib include share #{path}/")
          end
        end
      end

      def package_url(version)
        arch = amd64?() ? "x64" : "x86"
        "http://nodejs.org/dist/v0.10.26/node-#{version}-linux-#{arch}.tar.gz"
      end

    end

    register_dsl NodeJS, :nodejs

  end
end
