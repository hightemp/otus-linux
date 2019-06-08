
## Домашнее задание к уроку 9

### Создаю Vagrantfile для centos 7

```console
$ vagrant init centos/7
```

### Запускаю и захожу по ssh

```console
$ vagrant up
$ vagrant ssh
```

### Устанавливаю VirtualBox-5.1

```console
$ sudo su -
$ yum -y install gcc dkms make qt libgomp patch wget
$ yum -y install kernel-headers kernel-devel binutils glibc-headers glibc-devel font-forge
$ cd /etc/yum.repos.d/
$ wget http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo
$ yum install -y VirtualBox-5.1
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
$ yum install kernel-devel-3.10.0-957.5.1.el7.x86_64
$ /sbin/rcvboxdrv setup
```

### Устанавливаю Vagrant 1.9.6 64-bit

```console
$ yum -y install https://releases.hashicorp.com/vagrant/1.9.6/vagrant_1.9.6_x86_64.rpm
```

### Создаю папку и захожу в нее

```console
$ exit
$ mkdir ~/vagrant-home
$ cd ~/vagrant-home
```

### Проверяю версию python

> Версия Ansible =>2.4 требует длā своей работы Python 2.6 или выше

```console
$ python -V
```


