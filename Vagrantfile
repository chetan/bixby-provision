# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define("testing") do |cfg|
    cfg.vm.provider :virtualbox do |vb, override|
      # see: https://github.com/opscode/bento
      override.vm.box     = "ubuntu-12.04-x86_64"
      override.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"
    end
  end

  config.vm.define("testing-centos") do |cfg|
    cfg.vm.provider :virtualbox do |vb, override|
      override.vm.box     = "chef/centos-6.5"
    end
  end

  # common settings

  # config.vm.provision "shell", :privileged => false, :path => "scripts/bootstrap.sh"

  # for vagrant-vbguest plugin
  # https://github.com/dotless-de/vagrant-vbguest
  # config.vbguest.iso_path = "#{ENV['HOME']}/downloads/VBoxGuestAdditions_%{version}.iso"

  # shared folders
  config.vm.synced_folder ".", "/opt/bixby-provision"
  config.vm.synced_folder "../common", "/opt/bixby-common"
  config.vm.synced_folder "../client", "/opt/bixby-client"

  # Enable SSH agent forwarding for git clones
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb|
    vb.gui = false # Boot headless
    vb.customize [
      "modifyvm", :id,
      "--memory", "1024",
      "--cpus", "1",
      "--usb", "off",
      "--usbehci", "off",
      "--audio", "none"
    ]
  end

  config.vm.provider :aws do |aws, override|
    aws.region          = "us-east-1"
    aws.instance_type   = "c3.large"
    aws.security_groups = %w{ssh}

    override.vm.box     = "dummy"
    override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
  end

  config.vm.provider :digital_ocean do |ocean, override|
    ocean.region = "New York 2"
    ocean.size = "2GB"
    ocean.setup = true

    override.ssh.username = "bixby"
  end
end
