# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :inetRouter => {
      net: [
          { ip: '192.168.255.1', adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "router-net" },
      ],
      routes: [
          { dst: "192.168.0.0/16", src: "192.168.255.2", connection: "System eth1" },
      ],
      router: true,
  },
  :inetRouter2 => {
      net: [
          { ip: '192.168.254.1', adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "router2-net" },
      ],
      routes: [
          { dst: "192.168.0.0/16", src: "192.168.254.2", connection: "System eth1" },
      ],
      extForwardedPorts: [{
          guest: 80,
          host: 8080,
      }],
      router: true,
  },
  :centralRouter => {
      net: [
          { ip: '192.168.255.2', adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "router-net" },
          { ip: '192.168.254.2', adapter: 3, netmask: "255.255.255.252", virtualbox__intnet: "router2-net" },
          { ip: '192.168.0.1', adapter: 4, netmask: "255.255.255.240", virtualbox__intnet: "dir-net" },
      ],
      gateway: { ip: "192.168.255.1", connection: "System eth1" },
      dns: { ip: "8.8.8.8", connection: "System eth1" },
      router: true,
  },
  :centralServer => {
      net: [
          { ip: '192.168.0.2', adapter: 2, netmask: "255.255.255.240", virtualbox__intnet: "dir-net" },
      ],
      gateway: { ip: "192.168.0.1", connection: "System eth1" },
      dns: { ip: "8.8.8.8", connection: "System eth1" },
  },
}

Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
      config.vm.define boxname do |box|
          box.vm.box = "centos/7"
          box.vm.host_name = boxname.to_s

          box.ssh.insert_key = false

          boxconfig[:net].each do |ipconf|
              box.vm.network "private_network", ipconf
          end

          ######################## configure vms #############################
          case boxname.to_s
          when "inetRouter"
              box.vm.provision "shell", inline: <<-SHELL
                  iptables -t nat -A POSTROUTING ! -d 192.168.0.0/16 -o eth0 -j MASQUERADE
                  iptables -A INPUT -p tcp --dport 22 -i eth1 -j REJECT

                  yum install -y http://li.nux.ro/download/nux/misc/el6/i386/knock-server-0.5-7.el6.nux.i686.rpm
                  cp /vagrant/files/knockd.conf /etc/knockd.conf
                  systemctl start knockd
              SHELL
          when "inetRouter2"
              box.vm.provision "shell", inline: <<-SHELL
                  iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.0.2:8080
                  iptables -t nat -A POSTROUTING --destination 192.168.0.2/32 -j SNAT --to-source 192.168.254.1
              SHELL
          when "centralRouter"
              box.vm.provision "shell", inline: <<-SHELL
                  yum install -y nmap
              SHELL
          when "centralServer"
              box.vm.provision "shell", inline: <<-SHELL
                  yum install -y epel-release
                  yum install -y nginx

                  sed -i 's/80 default_server/8080 default_server/g' /etc/nginx/nginx.conf
                  systemctl enable --now nginx
              SHELL
          end

          ###################### configure network ###########################
          if boxconfig[:router] then
              box.vm.provision "shell", inline: <<-SHELL
                  echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
                  sysctl -p /etc/sysctl.conf
              SHELL
          end

          if boxconfig[:extForwardedPorts] then
              boxconfig[:extForwardedPorts].each do |p_conf|
                  box.vm.network "forwarded_port", p_conf
              end
          end

          if boxconfig[:routes] then
              boxconfig[:routes].each do |route|
                  box.vm.provision "shell" do |s|
                      s.inline = <<-SHELL
                          nmcli connection modify "$1" +ipv4.routes "$2 $3"
                          nmcli connection up "$1"
                      SHELL
                      s.args = [route[:connection], route[:dst], route[:src]]
                  end
              end
          end

          if boxconfig[:dns] then
              box.vm.provision "shell" do |s|
                  s.inline = <<-SHELL
                      nmcli connection modify "$1" ipv4.dns "$2"
                      nmcli connection up "$1"
                  SHELL
                  s.args = [boxconfig[:dns][:connection], boxconfig[:dns][:ip]]
              end
          end

          if boxconfig[:gateway] then
              box.vm.provision "shell" do |s|
                  s.inline = <<-SHELL
                      nmcli connection modify "$1" ipv4.gateway "$2"
                      nmcli connection up "$1"
                  SHELL
                  s.args = [boxconfig[:gateway][:connection], boxconfig[:gateway][:ip]]
              end
          end
      end
  end
end

