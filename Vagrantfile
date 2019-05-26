# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['HOME']
ENV["LC_ALL"] = "en_US.UTF-8"

MACHINES = {
  :lvm => {
        :box_name => "centos/7",
        :box_version => "1804.02",
        :ip_addr => '192.168.11.101',
    :disks => {
        :sata1 => {
            :dfile => home + '/VirtualBox VMs/sata1.vdi',
            :size => 10240,
            :port => 1
        },
        :sata2 => {
            :dfile => home + '/VirtualBox VMs/sata2.vdi',
            :size => 2048, # Megabytes
            :port => 2
        },
        :sata3 => {
            :dfile => home + '/VirtualBox VMs/sata3.vdi',
            :size => 1024, # Megabytes
            :port => 3
        },
        :sata4 => {
            :dfile => home + '/VirtualBox VMs/sata4.vdi',
            :size => 1024,
            :port => 4
        }
    }
  },
}

Vagrant.configure("2") do |config|

    config.vm.box_version = "1804.02"
    MACHINES.each do |boxname, boxconfig|
  
        config.vm.define boxname do |box|
  
            box.vm.box = boxconfig[:box_name]
            box.vm.host_name = boxname.to_s
  
            #box.vm.network "forwarded_port", guest: 3260, host: 3260+offset
  
            box.vm.network "private_network", ip: boxconfig[:ip_addr]
  
            box.vm.provider :virtualbox do |vb|
                    vb.customize ["modifyvm", :id, "--memory", "256"]
                    needsController = false
            boxconfig[:disks].each do |dname, dconf|
                unless File.exist?(dconf[:dfile])
                  vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Fixed', '--size', dconf[:size]]
                                  needsController =  true
                            end
  
            end
                    if needsController == true
                       vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]
                       boxconfig[:disks].each do |dname, dconf|
                           vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
                       end
                    end
            end
  
        box.vm.provision "shell", inline: <<-SHELL
            mkdir -p ~root/.ssh
            cp ~vagrant/.ssh/auth* ~root/.ssh
            yum install -y mdadm smartmontools hdparm gdisk
            sudo su -
            yum install -y redhat-lsb-core wget rpmdevtools rpm-build reaterepo yum-utils
            cd /home/vagrant
            mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
            yum install -y git
            git clone https://github.com/hightemp/getdents_ls.git
            yum install -y gcc
            yum install -y gcc-c++
            mkdir /tmp/gendents_ls
            cp -r getdents_ls/* /tmp/getdents_ls-1.0/
            cd /tmp
            tar -cvzf /home/vagrant/rpmbuild/SOURCES/getdents_ls-1.0.tar.gz getdents_ls-1.0
            cd /home/vagrant/rpmbuild/SPECS
            rpmdev-newspec getdents_ls
            cat >> getdents_ls.spec << EOF
Name:           getdents_ls
Version:        1.0
Release:        1%{?dist}
Summary:        Large directories viewer

License:       GPLv3+
URL:           https://github.com/hightemp/getdents_ls
Source0:       getdents_ls-1.0.tar.gz

BuildRequires: gcc
BuildRequires: make

%description


%prep
%setup -q


%build
make %{?_smp_mflags}


%install
%make_install


%files
%{_bindir}/%{name}
%doc



%changelog
EOF
            rpmbuild -bs getdents_ls.spec
            rpmbuild --rebuild /home/vagrant/rpmbuild/SRPMS/getdents_ls-1.0-1.el7.src.rpm
            rm -rf /home/vagrant/getdents_ls
            rm -rf /tmp/getdents_ls-1.0
            yum localinstall -y /home/vagrant/rpmbuild/RPMS/x86_64/getdents_ls-1.0-1.el7.x86_64.rpm
            cd /home/vagrant
            yum install -y epel-release
            yum install -y nginx
            mkdir /usr/share/nginx/html/repo
            cp /home/vagrant/rpmbuild/RPMS/x86_64/getdents_ls-1.0-1.el7.x86_64.rpm /usr/share/nginx/html/repo
            wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
            createrepo /usr/share/nginx/html/repo/
            mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
            awk -v RS="" '{sub(/location\s*\/\s*{[^}]*?}/,"location \/ { \n root \/usr\/share\/nginx\/html\/repo; \n index index.html index.htm; \n autoindex on; # Добавили эту директиву \n }")}1' /etc/nginx/nginx.conf.old > /etc/nginx/nginx.conf
            systemctl restart nginx
            cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost
gpgcheck=0
enabled=1
EOF
            yum install percona-release -y
          SHELL
  
        end
    end
  end
  
