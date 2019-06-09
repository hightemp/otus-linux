
## Домашнее задание к уроку 9

```console
$  uname -a
Linux hightemp.unknown.freename.su 3.10.0-957.12.2.el7.x86_64 #1 SMP Tue May 14 21:24:32 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
$ pwd
/root
```

### Устанавливаю VirtualBox-6.0 и утилиты

```console
$ yum -y install gcc dkms make qt libgomp patch wget rsync
$ yum -y install kernel-headers kernel-devel binutils glibc-headers glibc-devel font-forge
$ cd /etc/yum.repos.d/
$ wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo
$ yum install -y VirtualBox-6.0
$ /sbin/rcvboxdrv setup
```

### Получаю сообщение об ошибке

> vboxdrv.sh: Stopping VirtualBox services.
vboxdrv.sh: Building VirtualBox kernel modules.
This system is not currently set up to build kernel modules (system extensions).
Running the following commands should set the system up correctly:
>  yum install kernel-devel-3.10.0-957.5.1.el7.x86_64
(The last command may fail if your system is not fully updated.)
  yum install kernel-devel
vboxdrv.sh: failed: Look at /var/log/vbox-install.log to find out what went wrong.

### Устанавливаю пакет 

```console
$ yum -y install kernel-devel-3.10.0-957.5.1.el7.x86_64
$ /sbin/rcvboxdrv setup
```

### Устанавливаю Vagrant 2.2.4 64-bit

```console
$ yum -y install https://releases.hashicorp.com/vagrant/2.2.4/vagrant_2.2.4_x86_64.rpm
```

### Создаю папку и захожу в нее

```console
$ mkdir ~/vagrant-home
$ cd ~/vagrant-home
```

### Проверяю версию python

> Версия Ansible =>2.4 требует длā своей работы Python 2.6 или выше

```console
$ python -V
Python 2.7.5
```

### Устанавливаю Ansible

```console
$ yum -y install ansible
```

### Проверяю версию

```console
$ ansible --version
ansible 2.4.2.0
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.5 (default, Apr  9 2019, 14:30:50) [GCC 4.8.5 20150623 (Red Hat 4.8.5-36)]
```

### Создаю каталог с помощью ansible-galaxy

```console
$ ansible-galaxy init ansible
$ cd ansible/
$ ls
defaults  files  handlers  meta  README.md  tasks  templates  tests  vars
```

### Скачиваю Vagrantfile

```console
$ curl https://gist.githubusercontent.com/lalbrekht/f811ce9a921570b1d95e07a7dbebeb1e/raw/9d6f9e1ad06b257c3dc6d80a045baa6c5b75dd88/gistfile1.txt -o Vagrantfile
```

<details><summary>Для случаев запуска ВМ внутри ВМ</summary>
<p>

VirtualBox начал поддерживать Nested Virtualization в 6.0 версии

### Т.к. VirtualBox не поддерживает виртуализацию 64 битных машин внутри 64 битных заменяю образ на 32 битный

```console
$ sed -i "s/centos\/7/jasonc\/centos7-32bit/" Vagrantfile
```

Добавляю строки

```
            vb.customize ["modifyvm", :id, "--cpus", "1"]
            vb.customize ["modifyvm", :id, "--ioapic", "on"]
```

</p>
</details>

### Поднимаю ВМ

```console
$ vagrant up
```

### Проверяю параметры `vagrant ssh-config`

```console
$ vagrant ssh-config
Host nginx
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /root/vagrant-home/ansible/.vagrant/machines/nginx/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL
```

### Создаю inventory файл

```console
$ mkdir staging
$ cat > staging/hosts <<-EOF
[web]
nginx ansible_host=127.0.0.1 ansible_port=2222 ansible_user=vagrant ansible_private_key_file=/root/vagrant-home/ansible/.vagrant/machines/nginx/virtualbox/private_key
EOF
```

### Проеверяю

```console
$ ansible nginx -i staging/hosts -m ping
nginx | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```


### Создаю ansible.cfg

```console
$ cat > ansible.cfg <<-EOF
[defaults]
inventory = staging/hosts
remote_user = vagrant
host_key_checking = False
retry_files_enabled = False
EOF
```

### Удаляю из staging/hosts и-цию о пользователе

> ansible_user=vagrant

### Проверяю

```console
$ ansible nginx -m ping
nginx | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}
```

### Проверяю ядро на хосте

```console
$ ansible nginx -m command -a "uname -r"
nginx | SUCCESS | rc=0 >>
3.10.0-957.5.1.el7.x86_64

```

### Проверяю статус сервиса

```console
$ ansible nginx -m systemd -a name=firewalld
nginx | SUCCESS => {
    "changed": false, 
    "name": "firewalld", 
    "status": {
        "ActiveEnterTimestampMonotonic": "0", 
        "ActiveExitTimestampMonotonic": "0", 
        "ActiveState": "inactive", 
...
```

### Устанавливаю пакет epel-release

```console
$ ansible nginx -m yum -a "name=epel-release state=present" -b
nginx | SUCCESS => {
    "changed": true, 
    "msg": "warning: /var/cache/yum/x86_64/7/extras/packages/epel-release-7-11.noarch.rpm: Header V3 RSA/SHA256 Signature, key ID f4a80eb5: NOKEY\nImporting GPG key 0xF4A80EB5:\n Userid     : \"CentOS-7 Key (CentOS 7 Official Signing Key) <security@centos.org>\"\n Fingerprint: 6341 ab27 53d7 8a78 a7c2 7bb1 24c6 a8a7 f4a8 0eb5\n Package    : centos-release-7-6.1810.2.el7.centos.x86_64 (@anaconda)\n From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7\n", 
    "rc": 0, 
    "results": [
        "Loaded plugins: fastestmirror\nDetermining fastest mirrors\n * base: mirror.yandex.ru\n * extras: mirror.reconn.ru\n * updates: mirror.corbina.net\nResolving Dependencies\n--> Running transaction check\n---> Package epel-release.noarch 0:7-11 will be installed\n--> Finished Dependency Resolution\n\nDependencies Resolved\n\n================================================================================\n Package                Arch             Version         Repository        Size\n================================================================================\nInstalling:\n epel-release           noarch           7-11            extras            15 k\n\nTransaction Summary\n================================================================================\nInstall  1 Package\n\nTotal download size: 15 k\nInstalled size: 24 k\nDownloading packages:\nPublic key for epel-release-7-11.noarch.rpm is not installed\nRetrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7\nRunning transaction check\nRunning transaction test\nTransaction test succeeded\nRunning transaction\n  Installing : epel-release-7-11.noarch                                     1/1 \n  Verifying  : epel-release-7-11.noarch                                     1/1 \n\nInstalled:\n  epel-release.noarch 0:7-11                                                    \n\nComplete!\n"
    ]
}

```

### Создаю playbook в файле epel.yml

```console
$ cat > epel.yml <<-EOF
---
- name: Install EPEL Repo
  hosts: nginx
  become: true
  tasks:
    - name: Install EPEL Repo package from standart repo
      yum:
        name: epel-release
        state: present
EOF
```

### Звпускаю

```console
$ ansible-playbook epel.yml

PLAY [Install EPEL Repo] ***********************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************************************************************************
ok: [nginx]

TASK [Install EPEL Repo package from standart repo] ********************************************************************************************************************************************************************************************************************
ok: [nginx]

PLAY RECAP *************************************************************************************************************************************************************************************************************************************************************
nginx                      : ok=2    changed=0    unreachable=0    failed=0   

```

### Проверяю

```console
$ ansible nginx -m yum -a "name=epel-release state=absent" -b
nginx | SUCCESS => {
    "changed": true, 
    "msg": "", 
    "rc": 0, 
    "results": [
        "Loaded plugins: fastestmirror\nResolving Dependencies\n--> Running transaction check\n---> Package epel-release.noarch 0:7-11 will be erased\n--> Finished Dependency Resolution\n\nDependencies Resolved\n\n================================================================================\n Package                Arch             Version        Repository         Size\n================================================================================\nRemoving:\n epel-release           noarch           7-11           @extras            24 k\n\nTransaction Summary\n================================================================================\nRemove  1 Package\n\nInstalled size: 24 k\nDownloading packages:\nRunning transaction check\nRunning transaction test\nTransaction test succeeded\nRunning transaction\n  Erasing    : epel-release-7-11.noarch                                     1/1 \n  Verifying  : epel-release-7-11.noarch                                     1/1 \n\nRemoved:\n  epel-release.noarch 0:7-11                                                    \n\nComplete!\n"
    ]
}

$ ansible-playbook epel.yml

PLAY [Install EPEL Repo] ***********************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************************************************************************
ok: [nginx]

TASK [Install EPEL Repo package from standart repo] ********************************************************************************************************************************************************************************************************************
changed: [nginx]

PLAY RECAP *************************************************************************************************************************************************************************************************************************************************************
nginx                      : ok=2    changed=1    unreachable=0    failed=0   

```

### Создаю файл nginx.yml

```console
$ cat > nginx.yml <<-EOF
---
- name: NGINX | Install and configure NGINX
  hosts: nginx
  become: true
  
  tasks:
    - name: NGINX | Install EPEL Repo package from standart repo
      yum:
        name: epel-release
        state: present
      tags:
        - epel-package
        - packages

    - name: NGINX | Install NGINX package from EPEL Repo
      yum:
        name: nginx
        state: latest
      tags:
        - nginx-package
        - packages
EOF
```

### Проверяю

```console
$ ansible-playbook nginx.yml --list-tags

playbook: nginx.yml

  play #1 (nginx): NGINX | Install and configure NGINX	TAGS: []
      TASK TAGS: [epel-package, nginx-package, packages]
```

### Запускаю установку nginx

```console
$ ansible-playbook nginx.yml -t nginx-package

PLAY [NGINX | Install and configure NGINX] *****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************************************************************************
ok: [nginx]

TASK [NGINX | Install NGINX package from EPEL Repo] ********************************************************************************************************************************************************************************************************************
changed: [nginx]

PLAY RECAP *************************************************************************************************************************************************************************************************************************************************************
nginx                      : ok=2    changed=1    unreachable=0    failed=0   

```


