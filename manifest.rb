
first_boot do
  sys.refresh_packages
  upgrade_system
end

repo "rpmforge", :platforms => [:rhel, :centos]
package "sudo", "wget"

package "group-build_tools"
package %w{ntp screen curl git}
package "openssl-dev", "readline-dev", "zlib-dev", "curl-dev", "xslt-dev", "xml2-dev"

ntp.set "ntp.ubuntu.com"

ruby.install :path => "/usr/local"
gem "bundler", :version => "1.5.3"

dir.create "/var/cache/omnibus", :chown => "$USER"
dir.recreate "/opt/bixby", :chown => "$USER" # rm then create

checkout "https://github.com/chetan/bixby-omnibus.git", :path => "~/bixby-omnibus"
bundle.install "~/bixby-omnibus"

inventory.tap do
  tags "foo", "bar"
end

# monitoring.tap do
#   checks %w{cpu.loadavg cpu.usage fs.disk fs.inode net.conns net.throughput}
# end
