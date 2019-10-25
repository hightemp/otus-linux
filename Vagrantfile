# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {

  :host1 => {
    :box_name => "centos/7",
    :net => [
      {adapter: 2, auto_config: false, virtualbox__intnet: "vlan12"},
      {adapter: 3, auto_config: false, virtualbox__intnet: "vlan13"},
      {ip: '10.1.0.1', adapter: 4, netmask: "255.255.255.0", virtualbox__intnet: "intnet1"},
    ]
  }, 

  :host2 => {
    :box_name => "centos/7",
    :net => [
      {adapter: 2, auto_config: false, virtualbox__intnet: "vlan12"},
      {adapter: 3, auto_config: false, virtualbox__intnet: "vlan23"},
      {ip: '10.2.0.1', adapter: 4, netmask: "255.255.255.0", virtualbox__intnet: "intnet2"},
    ]
  }, 

  :host3 => {
    :box_name => "centos/7",
    :net => [
      {adapter: 2, auto_config: false, virtualbox__intnet: "vlan13"},
      {adapter: 3, auto_config: false, virtualbox__intnet: "vlan23"},
      {ip: '10.3.0.1', adapter: 4, netmask: "255.255.255.0", virtualbox__intnet: "intnet3"},
    ]
  }, 


}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|
      
    config.vm.define boxname do |box|

        box.vm.box = boxconfig[:box_name]
        box.vm.host_name = boxname.to_s

        config.vm.provider "virtualbox" do |v|
          v.memory = 256
        end

        boxconfig[:net].each do |ipconf|
          box.vm.network "private_network", ipconf
        end
        
        if boxconfig.key?(:public)
          box.vm.network "public_network", boxconfig[:public]
        end

        box.vm.provision "shell", inline: <<-SHELL
          mkdir -p ~root/.ssh
                cp ~vagrant/.ssh/auth* ~root/.ssh
        SHELL
        
    end

    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook"+ENV['TASK']+".yml"
    end

  end
  
  
end
