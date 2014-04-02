
require 'jeweler'

Jeweler::Tasks.new do |gemspec|
  gemspec.name        = "bixby-provision"
  gemspec.summary     = "Bixby Provision"
  gemspec.description = "Bixby Provisioner"
  gemspec.email       = "chetan@pixelcop.net"
  gemspec.homepage    = "http://github.com/chetan/bixby-provision"
  gemspec.authors     = ["Chetan Sarva"]
  gemspec.license     = "MIT"

  gemspec.executables = %w{ bixby-provision }

  # exclude these bin scripts for now
  # %w{ bin/bundle bin/cache_all.rb bin/install.sh bin/old_install.sh bin/package }.each do |f|
  #   gemspec.files.exclude f
  # end

end
Jeweler::RubygemsDotOrgTasks.new
