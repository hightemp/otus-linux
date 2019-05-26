
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
```

### Создаю директорию rpmbuild

```console
$ mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
```

### Устанавливаю git

```console
$ sudo yum install -y git
```

### Копирую репозиторий

```console
$ git clone https://github.com/hightemp/getdents_ls.git
```

### Устанавливаю gcc

```console
$ sudo yum install -y gcc
$ sudo yum install -y gcc-c++ 
```

### Собираю tarball

```console
$ mkdir /tmp/gendents_ls
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

### Создаю пакеты

#### С исходниками

```console
$ rpmbuild -bs getdents_ls.spec
```

#### С бинарниками

```console
$ rpmbuild --rebuild ~/rpmbuild/SRPMS/getdents_ls-1.0-1.el7.src.rpm
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
$ sudo yum localinstall -y ~/rpmbuild/RPMS/x86_64/getdents_ls-1.0-1.el7.x86_64.rpm
```

## Создание репозитория

### Устанавливаю nginx

```console
$ cd ~
$ sudo yum install -y epel-release
$ sudo yum install -y nginx
```

### Создаю директорию repo

```console
$ sudo mkdir /usr/share/nginx/html/repo
```

### Копирую файлы

```console
$ sudo cp ~/rpmbuild/RPMS/x86_64/getdents_ls-1.0-1.el7.x86_64.rpm /usr/share/nginx/html/repo
```

### Добавляю еще один пакет

```console
$ sudo wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
```

### Создаю репозиторий

```console
$ sudo createrepo /usr/share/nginx/html/repo/
```

### Изменяю конфигурационный файл nginx /etc/nginx/nginx.conf

```console
$ sudo vi /etc/nginx/nginx.conf
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
$ sudo nginx -t
```

```console
$ sudo systemctl start nginx
```
или 

```
$ sudo nginx -s reload
```

### Устанавливаю lynx 

```console
$ sudo yum install -y lynx
```

### Захожу спомощью lynx на localhost

```console
$ lynx http://localhost
```

![](/images/lesson6/Screenshot_20190526_185143.png)
