
sys.refresh_packages
upgrade_system

repo "rpmforge", :platforms => [:rhel, :centos]
package "sudo", "wget"

package "group-build_tools"
package "ntp", "screen", "curl", "git"
package "openssl-dev", "readline-dev", "zlib-dev", "curl-dev", "xslt-dev", "xml2-dev"

ntp.set "ntp.ubuntu.com"

ruby.install :path => "/usr/local"
gem "bundler", :version => "1.5.3"

dir.create "/var/cache/omnibus", :chown => "$USER"
dir.recreate "/opt/bixby", :chown => "$USER" # rm then create

checkout "https://github.com/chetan/bixby-omnibus.git", :path => "~/bixby-omnibus"
bundle.install "~/bixby-omnibus"
