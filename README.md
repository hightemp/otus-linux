
## Домашнее задание к уроку 6

###  Устанавливаю необходимые пакеты

```console
sudo yum install -y \
redhat-lsb-core \
wget \
rpmdevtools \
rpm-build \
createrepo \
yum-utils
```

## Создание свое пакета

```console
[vagrant@lvm ~]$ pwd
/home/vagrant
[vagrant@lvm ~]$ whoami
vagrant
```

### Создаю директорию rpmbuild

```console
mkdir -p rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
```

### Устанавливаю git

```console
sudo yum install -y git
```

### Копирую репозиторий

```console
git clone https://github.com/hightemp/getdents_ls.git
```

### Устанавливаю gcc

```console
sudo yum install -y gcc
sudo yum install -y gcc-c++ 
```

### Собираю tarball

```console
mkdir /tmp/gendents_ls
cp -r getdents_ls/* /tmp/getdents_ls-1.0/
cd /tmp
tar -cvzf ~/rpmbuild/SOURCES/getdents_ls-1.0.tar.gz getdents_ls-1.0
```

### Создаю SPEC файл

```console
cd ~/rpmbuild/SPECS
rpmdev-newspec getdents_ls
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
rpmbuild -bs getdents_ls.spec
```

#### С бинарниками

```console
rpmbuild --rebuild ~/rpmbuild/SRPMS/getdents_ls-1.0-1.el7.src.rpm
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
