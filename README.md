
## Домашнее задание к уроку 9

### Создаю каталог с помощью ansible-galaxy

```console
$ mkdir roles
$ cd roles
$ ansible-galaxy init nginx
$ cd nginx/
$ ls
defaults  files  handlers  meta  README.md  tasks  templates  tests  vars
```

### Скачиваю Vagrantfile

```console
$ cd ../..
$ curl https://gist.githubusercontent.com/lalbrekht/f811ce9a921570b1d95e07a7dbebeb1e/raw/9d6f9e1ad06b257c3dc6d80a045baa6c5b75dd88/gistfile1.txt -o Vagrantfile
```

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
  Port 2202
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /home/hightemp/Otus/Linux/lesson9/.vagrant/machines/nginx/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL
```

### Создаю inventory файл

```console
$ mkdir roles/nginx/staging
$ cat > roles/nginx/staging/hosts <<-EOF
[web]
nginx ansible_host=127.0.0.1 ansible_port=2202 ansible_user=vagrant ansible_private_key_file=./.vagrant/machines/nginx/virtualbox/private_key
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
inventory = roles/nginx/staging/hosts
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
nginx | CHANGED | rc=0 >>
3.10.0-957.12.2.el7.x86_64

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

### Добавляю шаблон в playbook, номер порта, handler'ы

```console
$ cat > nginx.yml <<-EOF
---
- name: NGINX | Install and configure NGINX
  hosts: nginx
  become: true
  vars:
    nginx_listen_port: 8080

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
      notify:
        - restart nginx
      tags:
        - nginx-package
        - packages

    - name: NGINX | Create NGINX config file from template
      template:
        src: ../roles/nginx/templates/nginx.conf.j2
        dest: /etc/nginx/nginx.conf
      notify:
        - reload nginx
      tags:
        - nginx-configuration

  handlers:
    - name: restart nginx
      systemd:
        name: nginx
        state: restarted
        enabled: yes
    
    - name: reload nginx
      systemd:
        name: nginx
        state: reloaded
EOF
$ mkdir playbooks
$ mv *.yml playbooks
```

```console
$ cat > roles/nginx/templates/nginx.conf.j2 <<-EOF
# {{ ansible_managed }}
events {
    worker_connections 1024;
}

http {
    server {
        listen       {{ nginx_listen_port }} default_server;
        server_name  default_server;
        root         /usr/share/nginx/html;

        location / {
        }
    }
}
EOF
```

### Запускаю

```console
$ ansible-playbook playbooks/nginx.yml
PLAY [NGINX | Install and configure NGINX] *****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************************************************************************************************************************
ok: [nginx]

TASK [NGINX | Install EPEL Repo package from standart repo] ************************************************************************************************************************************************************************************************************
ok: [nginx]

TASK [NGINX | Install NGINX package from EPEL Repo] ********************************************************************************************************************************************************************************************************************
ok: [nginx]

TASK [NGINX | Create NGINX config file from template] ******************************************************************************************************************************************************************************************************************
changed: [nginx]

RUNNING HANDLER [reload nginx] *****************************************************************************************************************************************************************************************************************************************
changed: [nginx]

PLAY RECAP *************************************************************************************************************************************************************************************************************************************************************
nginx                      : ok=5    changed=2    unreachable=0    failed=0   

```

### Проверяю

```console
$ lynx 192.168.11.150:8080
```

![](/images/lesson9/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202019-10-24%2000-48-32.png)