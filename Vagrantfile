# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
    :inetRouter => {
        net: [
            { adapter: 2, virtualbox__intnet: "router-net" },
            { adapter: 3, virtualbox__intnet: "router-net" },
        ],
        bonding: {
            conName: "bond1",
            address: "192.168.255.1/30",
            devices: "eth1 eth2",
        },
        routes: [
            { dst: "192.168.0.0/16", src: "192.168.255.2", connection: "bond1" },
        ],
        masquerade: true,
        isRouter: true,
    },
    :centralRouter => {
        net: [
            { adapter: 2, virtualbox__intnet: "router-net" },
            { adapter: 3, virtualbox__intnet: "router-net" },
            { ip: '192.168.0.1', adapter: 4, netmask: "255.255.255.240", virtualbox__intnet: "dir-net" },
            { ip: '192.168.0.33', adapter: 5, netmask: "255.255.255.240", virtualbox__intnet: "hw-net" },
            { ip: '192.168.0.65', adapter: 6, netmask: "255.255.255.192", virtualbox__intnet: "mgt-net" },
            { ip: '192.168.255.9', adapter: 7, netmask: "255.255.255.248", virtualbox__intnet: "central-net" },
        ],
        bonding: {
            conName: "bond1",
            address: "192.168.255.2/30",
            devices: "eth1 eth2",
        },
        routes: [
            { dst: "192.168.1.0/24", src: "192.168.255.11", connection: "System eth6" },
            { dst: "192.168.2.0/24", src: "192.168.255.10", connection: "System eth6" },
        ],
        gateway: { ip: "192.168.255.1", connection: "bond1" },
        dns: { ip: "8.8.8.8", connection: "bond1" },
        isRouter: true,
    },
    :centralServer => {
        net: [
            { ip: '192.168.0.2', adapter: 2, netmask: "255.255.255.240", virtualbox__intnet: "dir-net" },
        ],
        gateway: { ip: "192.168.0.1", connection: "System eth1" },
        dns: { ip: "8.8.8.8", connection: "System eth1" },
    },
    :office1Router => {
        net: [
            { ip: '192.168.255.10', adapter: 2, netmask: "255.255.255.248", virtualbox__intnet: "central-net" },
            { ip: '192.168.2.1', adapter: 3, netmask: "255.255.255.192", virtualbox__intnet: "test-net" },
            { ip: '192.168.2.65', adapter: 4, netmask: "255.255.255.192", virtualbox__intnet: "test-net" },
            { ip: '192.168.2.129', adapter: 5, netmask: "255.255.255.192", virtualbox__intnet: "managers1-net" },
            { ip: '192.168.2.193', adapter: 6, netmask: "255.255.255.192", virtualbox__intnet: "hw1-net" },
        ],
        gateway: { ip: "192.168.255.9", connection: "System eth1" },
        dns: { ip: "8.8.8.8", connection: "System eth1" },
        isRouter: true,
    },
    :testClient1 => {
        net: [
            { ip: '192.168.2.3', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "test-net" },
        ],
        vlans: [
            { vlanID: 2, interface: "eth1", ip: "10.10.10.254/24"},
        ],
        gateway: { ip: "192.168.2.1", connection: "System eth1" },
        dns: { ip: "8.8.8.8", connection: "System eth1" },
    },
    :testServer1 => {
        net: [
            { ip: '192.168.2.66', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "test-net" },
        ],
        vlans: [
            { vlanID: 2, interface: "eth1", ip: "10.10.10.1/24"},
        ],
        gateway: { ip: "192.168.2.65", connection: "System eth1" },
        dns: { ip: "8.8.8.8", connection: "System eth1" },
    },
    :testClient2 => {
        net: [
            { ip: '192.168.2.4', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "test-net" },
        ],
        vlans: [
            { vlanID: 3, interface: "eth1", ip: "10.10.10.254/24"},
        ],
        gateway: { ip: "192.168.2.1", connection: "System eth1" },
        dns: { ip: "8.8.8.8", connection: "System eth1" },
    },
    :testServer2 => {
        net: [
            { ip: '192.168.2.67', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "test-net" },
        ],
        vlans: [
            { vlanID: 3, interface: "eth1", ip: "10.10.10.1/24"},
        ],
        gateway: { ip: "192.168.2.65", connection: "System eth1" },
        dns: { ip: "8.8.8.8", connection: "System eth1" },
    },
    :office1Server => {
        net: [
            { ip: '192.168.2.2', adapter: 3, netmask: "255.255.255.192", virtualbox__intnet: "dev1-net" },
        ],
        gateway: { ip: "192.168.2.1", connection: "System eth1" },
        dns: { ip: "8.8.8.8", connection: "System eth1" },
    },
    :office2Router => {
        net: [
            { ip: '192.168.255.11', adapter: 2, netmask: "255.255.255.248", virtualbox__intnet: "central-net" },
            { ip: '192.168.1.1', adapter: 3, netmask: "255.255.255.128", virtualbox__intnet: "dev2-net" },
            { ip: '192.168.1.129', adapter: 4, netmask: "255.255.255.192", virtualbox__intnet: "test2-net" },
            { ip: '192.168.1.193', adapter: 5, netmask: "255.255.255.192", virtualbox__intnet: "hw2-net" },
        ],
        gateway: { ip: "192.168.255.9", connection: "System eth1" },
        dns: { ip: "8.8.8.8", connection: "System eth1" },
        isRouter: true,
    },
    :office2Server => {
        net: [
            { ip: '192.168.1.2', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "dev2-net" },
        ],
        gateway: { ip: "192.168.1.1", connection: "System eth1" },
        dns: { ip: "8.8.8.8", connection: "System eth1" },
    },
}

Vagrant.configure("2") do |config|
    MACHINES.each do |boxname, boxconfig|
        config.vm.define boxname do |box|
            # oFile = File.open("./tmp/"+boxname.to_s+".txt", "w")

            box.vm.box = "centos/7"
            box.vm.host_name = boxname.to_s

            box.ssh.insert_key = false
            box.ssh.forward_agent = true

            boxconfig[:net].each do |ipconf|
                box.vm.network "private_network", ipconf
            end

            box.vm.provision "shell", inline: "nmcli connection delete '' 2>/dev/null || :"
        end
    end

    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml"
    end
end

