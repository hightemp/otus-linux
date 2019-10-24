# -*- mode: ruby -*-
# vi: set ft=ruby :

MACHINES = {
  :grafana => {
    :box_name => "centos/7",
    :ip_addr => '192.168.11.150',
    :forwarded_port => [ 9090, 3000 ]
  },
  # :zabbix => {
  #   :box_name => "centos/7",
  #   :ip_addr => '192.168.11.151'
  # }
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

      config.vm.define boxname do |box|

          box.vm.box = boxconfig[:box_name]
          box.vm.host_name = boxname.to_s

          box.vm.network "private_network", ip: boxconfig[:ip_addr]

          if (boxconfig.key?(:forwarded_port))
            boxconfig[:forwarded_port].each do |port|
              box.vm.network "forwarded_port", guest: port, host: port
            end
          end

          box.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--memory", "1000"]
          end
          
          box.vm.provision "shell", inline: <<-SHELL
            mkdir -p ~root/.ssh; cp ~vagrant/.ssh/auth* ~root/.ssh
            sed -i '65s/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
            systemctl restart sshd
          SHELL

      end
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  end

end
