# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['HOME']
ENV["LC_ALL"] = "en_US.UTF-8"

MACHINES = {
  :centos => {
        :box_name => "centos/7",
        :ip_addr => '192.168.11.101'
  }
}


Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

      config.vm.define boxname do |box|

          box.vm.box = boxconfig[:box_name]
          box.vm.host_name = boxname.to_s

          #box.vm.network "forwarded_port", guest: 3260, host: 3260+offset

          box.vm.network "private_network", ip: boxconfig[:ip_addr]

          box.vm.provider :virtualbox do |vb|
            vb.customize ["modifyvm", :id, "--memory", "256"]
          end

          box.vm.provision "shell", inline: <<-SHELL
            mkdir -p ~root/.ssh
            cp ~vagrant/.ssh/auth* ~root/.ssh
            yum install -y mdadm smartmontools hdparm gdisk
            sudo su -
            yum install -y redhat-lsb-core wget rpmdevtools rpm-build reaterepo yum-utils
            cd ~
            mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
            yum install -y git
            git clone https://github.com/hightemp/getdents_ls.git
            yum install -y gcc
            yum install -y gcc-c++
            mkdir /tmp/getdents_ls-1.0
            cp -r getdents_ls/* /tmp/getdents_ls-1.0/
            cd /tmp
            tar -cvzf ~/rpmbuild/SOURCES/getdents_ls-1.0.tar.gz getdents_ls-1.0
            cd ~/rpmbuild/SPECS
            rpmdev-newspec getdents_ls
            cat > getdents_ls.spec << EOF
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
            rpmbuild -bb getdents_ls.spec
            rm -rf ~/getdents_ls
            rm -rf /tmp/getdents_ls-1.0
            yum localinstall -y ~/rpmbuild/RPMS/x86_64/getdents_ls-1.0-1.el7.x86_64.rpm
            cd ~
            yum install -y epel-release
            yum install -y nginx
            mkdir /usr/share/nginx/html/repo
            cp ~/rpmbuild/RPMS/x86_64/getdents_ls-1.0-1.el7.x86_64.rpm /usr/share/nginx/html/repo
            wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
            createrepo /usr/share/nginx/html/repo/
            mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
            awk -v RS="" '{sub(/location\\s*\\/\\s*{[^}]*?}/,"location / { \\n root \/usr\/share\/nginx\/html\/repo; \\n index index.html index.htm; \\n autoindex on; # Добавили эту директиву \\n }")}1' /etc/nginx/nginx.conf.old > /etc/nginx/nginx.conf
            # systemctl restart nginx
            nginx
            cat > /etc/yum.repos.d/otus.repo << EOF
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
  
