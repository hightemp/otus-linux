# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "log" do |log|
    log.vm.box = "centos/7"
    log.vm.box_check_update = false

    log.vm.hostname = "log"
    log.vm.network "private_network", ip: "10.0.10.2"
  end

  config.vm.define "web" do |web|
    web.vm.box = "centos/7"
    web.vm.box_check_update = false

    web.vm.hostname = "web"
    web.vm.network "private_network", ip: "10.0.10.3"
  end

  config.vm.provision "shell", inline: <<-SHELL
    mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh
    sed -i '65s/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    systemctl restart sshd
  SHELL

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  end
end
