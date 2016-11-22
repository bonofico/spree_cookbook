# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = '4096'
    vb.cpus = '4'
    vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
  end

  config.vm.network "forwarded_port", guest: '80', host: '8080'

  config.vm.provision "shell", inline:<<-EOH
    if ! [[ "$(chef-client -v)" =~ "12.9.41" ]]
    then
      dpkg -i /vagrant/chef_12.9.41-1_amd64.deb
    fi
  EOH

  config.vm.provision 'chef_solo' do |chef|
    chef.add_recipe 'spree'
    chef.cookbooks_path = '../'
  end

end
