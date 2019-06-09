
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











