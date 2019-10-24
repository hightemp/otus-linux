# -*- mode: ruby -*-
# vi: set ft=ruby :

MACHINES = {
  :"backup-server" => {
    :box_name => "centos/7",
    :ip_addr => '192.168.11.150',
    :shell => <<-SHELL
    yum install -y bacula-director bacula-storage bacula-console postgresql-server policycoreutils-python
    if [[ ! -f /etc/postgres-inited ]]; then

      postgresql-setup initdb
      sed -i "s/local   all             all                                     peer/local   all             all                                     peer\\nhost    bacula          bacula          127.0.0.1\\/32            md5\\nhost    bacula          bacula          ::1\\/128                 md5/" /var/lib/pgsql/data/pg_hba.conf
      systemctl restart postgresql

      PG_BACULA_PASSWORD=`date +%s | sha256sum | base64 | head -c 33`
      su - postgres <<EOF
/usr/libexec/bacula/create_postgresql_database
/usr/libexec/bacula/make_postgresql_tables
/usr/libexec/bacula/grant_postgresql_privileges
psql bacula -c "alter user bacula with password '$PG_BACULA_PASSWORD'"
EOF

        echo "localhost:5432:bacula:bacula:"$PG_BACULA_PASSWORD > /var/spool/bacula/.pgpass
      chown bacula:bacula /var/spool/bacula/.pgpass
      chmod 600 /var/spool/bacula/.pgpass
      systemctl restart postgresql
      touch /etc/postgres-inited
    fi

    if [[ ! -f /etc/bacula-inited ]]; then
      #  make sure .conf files are in same directory as Vagrantfile
      mkdir -p /etc/bacula/examples/
      cp /etc/bacula/*.conf /etc/bacula/examples/.
      cp /vagrant/files/*.conf /etc/bacula/.
      chown -R root:root /etc/bacula
      chmod 755 /etc/bacula
      chmod 640 /etc/bacula/*
      chgrp bacula /etc/bacula/bacula-dir.conf /etc/bacula/query.sql
      #  Setting rights - http://www.backupcentral.com/phpBB2/two-way-mirrors-of-external-mailing-lists-3/bacula-25/permission-problem-on-centos-6-5-and-bacula-7-125732/

      #  Set Bacula Component Passwords
      #  https://www.digitalocean.com/community/tutorials/how-to-install-bacula-server-on-centos-7
      sed -i "s/@@FD_PASSWORD@@/N2I3NzNmYTg3YzMwOWMzN2NhOTljNmMzY/g" /etc/bacula/bacula-dir.conf
      sed -i "s/@@FD_PASSWORD@@/N2I3NzNmYTg3YzMwOWMzN2NhOTljNmMzY/g" /etc/bacula/bacula-fd.conf
      DIR_PASSWORD=`date +%s | sha256sum | base64 | head -c 33`
      sed -i "s/@@DIR_PASSWORD@@/$DIR_PASSWORD/g" /etc/bacula/bacula-dir.conf
      sed -i "s/@@DIR_PASSWORD@@/$DIR_PASSWORD/g" /etc/bacula/bconsole.conf
      SD_PASSWORD=`date +%s | sha256sum | base64 | head -c 33`
      sed -i "s/@@SD_PASSWORD@@/$SD_PASSWORD/g" /etc/bacula/bacula-dir.conf
      sed -i "s/@@SD_PASSWORD@@/$SD_PASSWORD/g" /etc/bacula/bacula-sd.conf

      # script folder does not exist
      mkdir -p /bacula/backup /bacula/restore
      chown -R bacula:bacula /bacula
      chmod -R 700 /bacula
      semanage fcontext -a -t bacula_store_t "/bacula(/.*)?"
      restorecon -R -v /bacula
      touch /etc/bacula-inited
    fi

    systemctl restart bacula-sd bacula-fd bacula-dir
    systemctl enable bacula-sd bacula-fd bacula-dir postgresql    
    SHELL
  },
  :"backup-client-1" => {
    :box_name => "centos/7",
    :ip_addr => '192.168.11.151',
    :shell => <<-SHELL
    if [[ $(getent passwd eventstore >/dev/null) -ne 0 ]]; then
      # Create eventstore
      mkdir /var/lib/eventstore
      groupadd -r eventstore
      useradd -d /var/lib/eventstore -r -g eventstore eventstore
      chown -R eventstore:eventstore /var/lib/eventstore
      chmod -R 755 /var/lib/eventstore
      touch /etc/sysconfig/eventstore
    fi
    if [[ ! -f /etc/client-inited ]]; then
      #  make sure .conf files are in same directory as Vagrantfile
      mkdir -p /etc/bacula/examples/
      cp /etc/bacula/bacula-fd.conf /etc/bacula/examples/.
      cp /vagrant/files/bacula-fd.client1_conf /etc/bacula/bacula-fd.conf
      sed -i "s/@@FD_PASSWORD@@/N2I3NzNmYTg3YzMwOWMzN2NhOTljNmMzY/" /etc/bacula/bacula-fd.conf
      mkdir -p /bacula/restore
      chown -R bacula:bacula /bacula
      chmod -R 700 /bacula
      touch /etc/client-inited
    fi
    systemctl restart bacula-fd
    systemctl enable bacula-fd
  SHELL
  },
  :"backup-client-2" => {
    :box_name => "centos/7",
    :ip_addr => '192.168.11.152',
    :shell => <<-SHELL
    if [[ $(getent passwd eventstore >/dev/null) -ne 0 ]]; then
      # Create eventstore
      mkdir /var/lib/eventstore
      groupadd -r eventstore
      useradd -d /var/lib/eventstore -r -g eventstore eventstore
      chown -R eventstore:eventstore /var/lib/eventstore
      chmod -R 755 /var/lib/eventstore
      touch /etc/sysconfig/eventstore
    fi
    if [[ ! -f /etc/client-inited ]]; then
      #  make sure .conf files are in same directory as Vagrantfile
      mkdir -p /etc/bacula/examples/
      cp /etc/bacula/bacula-fd.conf /etc/bacula/examples/.
      cp /vagrant/files/bacula-fd.client2_conf /etc/bacula/bacula-fd.conf
      sed -i "s/@@FD_PASSWORD@@/N2I3NzNmYTg3YzMwOWMzN2NhOTljNmMzY/" /etc/bacula/bacula-fd.conf
      mkdir -p /bacula/restore
      chown -R bacula:bacula /bacula
      chmod -R 700 /bacula
      touch /etc/client-inited
    fi
    systemctl restart bacula-fd
    systemctl enable bacula-fd
  SHELL
  },
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

      config.vm.box_check_update = true

      config.vm.provision "shell", inline: <<-SHELL
        set -x
        yum update -y && yum upgrade -y
        yum install -y bacula-client
      SHELL

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
          
          if (boxconfig.key?(:shell))
            box.vm.provision "shell", inline: boxconfig[:shell]
          end

      end
  end

end
