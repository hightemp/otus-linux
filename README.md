
## Домашнее задание к уроку 6

###  Устанавливаю необходимые пакеты

```console
$ sudo yum install -y \
redhat-lsb-core \
wget \
rpmdevtools \
rpm-build \
createrepo \
yum-utils
```

## Создание своего пакета

```console
$ pwd
/home/vagrant
$ whoami
vagrant
$ sudo su -
$ cd ~
```

### Создаю директорию rpmbuild

```console
$ mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
```

### Устанавливаю git

```console
$ yum install -y git
```

### Копирую репозиторий

```console
$ git clone https://github.com/hightemp/getdents_ls.git
```

### Устанавливаю gcc

```console
$ yum install -y gcc
$ yum install -y gcc-c++ 
```

### Собираю tarball

```console
$ mkdir /tmp/getdents_ls-1.0
$ cp -r getdents_ls/* /tmp/getdents_ls-1.0/
$ cd /tmp
$ tar -cvzf ~/rpmbuild/SOURCES/getdents_ls-1.0.tar.gz getdents_ls-1.0
```

### Создаю SPEC файл

```console
$ cd ~/rpmbuild/SPECS
$ rpmdev-newspec getdents_ls
```

### Вставляю в getdents_ls.spec следующее

```
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

```

### Создаю пакет

```console
$ rpmbuild -bb getdents_ls.spec
```

### Проверяю наличие пакетов

![](/images/lesson6/Screenshot_20190526_163256.png)

### Удаляю директории

```console
$ rm -rf ~/getdents_ls
$ rm -rf /tmp/getdents_ls-1.0 
```

### Устанавливаю пакет

```console
$ yum localinstall -y ~/rpmbuild/RPMS/x86_64/getdents_ls-1.0-1.el7.x86_64.rpm
```

## Создание репозитория

### Устанавливаю nginx

```console
$ cd ~
$ yum install -y epel-release
$ yum install -y nginx
```

### Создаю директорию repo

```console
$ mkdir /usr/share/nginx/html/repo
```

### Копирую файлы

```console
$ cp ~/rpmbuild/RPMS/x86_64/getdents_ls-1.0-1.el7.x86_64.rpm /usr/share/nginx/html/repo
```

### Добавляю еще один пакет

```console
$ wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
```

### Устанавливаю createrepo

```console
$ yum install -y createrepo
```

### Создаю репозиторий

```console
$ createrepo /usr/share/nginx/html/repo/
```

### Изменяю конфигурационный файл nginx /etc/nginx/nginx.conf

```console
$ vi /etc/nginx/nginx.conf
```

```nginx
# ...
location / {
    root /usr/share/nginx/html/repo;
    index index.html index.htm;
    autoindex on; # Добавили эту директиву
}
# ...
```

### Перезапускаю

```console
$ nginx -t
```

```console
$ systemctl start nginx
```
или 

```
$ nginx -s reload
```

### Устанавливаю lynx 

```console
$ yum install -y lynx
```

### Захожу спомощью lynx на localhost

```console
$ lynx http://localhost
```

![](/images/lesson6/Screenshot_20190526_185143.png)

### Добавляю репозиторий

```console
$ cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost
gpgcheck=0
enabled=1
EOF
```

### Проверяю

```console
$ yum repolist enabled | grep otus
$ yum list | grep otus
```

![](/images/lesson6/Screenshot_20190526_190402.png)

### Устанавливаю второй пакет

```console
$ yum install percona-release -y
```

![](/images/lesson6/Screenshot_20190526_190803.png)

