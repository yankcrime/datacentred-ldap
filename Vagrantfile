# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box         = 'datacentred/ubuntu-trusty64-puppet'
  config.vm.box_version = '0.1.1'

  # Make the NAT engine use the host's resolver mechanisms to handle DNS requests
  config.vm.provider "virtualbox" do |virtualbox|
    virtualbox.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  # Port Forwarding
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 443, host: 4443

  # Puppet provisioner
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path    = "vagrant"
    #puppet.module_path       = "modules"
    puppet.options           = "--verbose "
    puppet.facter            = {
                                 "environment" => "production",
                                 "is_vagrant" => "true",
                               }
  end
end
