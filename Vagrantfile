# -*- mode: ruby -*-
# vi: set ft=ruby :

MACHINES = {
  :ns01 => {
    :ip_addr => '10.0.10.1'
  },
  :ns02 => {
    :ip_addr => '10.0.10.2'
  },
  :client1 => {
    :ip_addr => '10.0.10.3'
  },
  :client2 => {
    :ip_addr => '10.0.10.4'
  },
}

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "files/playbook.yml"
  end

  MACHINES.each do |boxname, boxconfig|

    config.vm.define boxname.to_s do |ns01|
      ns01.vm.network "private_network", ip: boxconfig[:ip_addr], virtualbox__intnet: "dns"
      ns01.vm.hostname = boxname.to_s
    end
    
  end

end
