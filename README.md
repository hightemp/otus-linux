
## Домашнее задание к уроку 7

```console
$ sudo su -
```

## Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig

### Создаю файл с переменными среды

```console
$ cat > /etc/sysconfig/watchlog << EOF
WORD="ALERT"
LOG=/var/log/watchlog.log
EOF
```

### Создаю скрипт, который будет запускаться

```console
$ cat > /opt/watchlog.sh << EOF
#!/bin/bash
WORD=\$1
LOG=\$2
DATE=\`date\`
for iPosition in \`grep -aob \$WORD \$LOG | grep -oE '[0-9]+'\`; do
    logger "\$DATE: [\$LOG] Word '\$WORD' found at \$iPosition"
done
EOF
```

### Создаю юнит файл для скрипта

```console
$ cat > /usr/lib/systemd/system/watchlog.service << EOF
[Unit]
Description=My watchlog service
[Service]
Type=oneshot
EnvironmentFile=/etc/sysconfig/watchlog
ExecStart=/opt/watchlog.sh \$WORD \$LOG
EOF
```

### Создаю юнит файл для таймера

```console
$ cat > /usr/lib/systemd/system/watchlog.timer << EOF
[Unit]
Description=Run watchlog script every 30 second
[Timer]
# Run every 30 second
OnUnitActiveSec=30
Unit=watchlog.service
[Install]
WantedBy=multi-user.target
EOF
```

### Добавляю права на выполнение скрипту

```console
$ chmod +x /opt/watchlog.sh
```

### Запускаю сервисы

```console
$ systemctl start watchlog.timer
```

### Добавляю запись в лог файл

```console
$ echo "ALERT" >> /var/log/watchlog.log
```

### Проверяю результат

```console
$ tail -f /var/log/watchlog.log
```

![](images/lesson7/Screenshot_20190526_234134.png)

## Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно также называться.

### Устанавливаю spawn-fcgi + доп. пакеты

```console
$ yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y
```

### Редактирую /etc/sysconfig/spawn-fcgi

```console
$ cat > /etc/sysconfig/spawn-fcgi << EOF
# You must set some working options before the "spawn-fcgi" service will work.
# If SOCKET points to a file, then this file is cleaned up by the init script.
#
# See spawn-fcgi(1) for all possible options.
#
# Example :
SOCKET=/var/run/php-fcgi.sock
OPTIONS="-u apache -g apache -s $SOCKET -S -M 0600 -C 32 -F 1 -P /var/run/fastcgi-php.pid -- /usr/bin/php-cgi"
EOF
```

### Создаю юнит файл /etc/systemd/system/spawn-fcgi.service

```console
$ cat > /etc/systemd/system/spawn-fcgi.service << EOF
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target
[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/sysconfig/spawn-fcgi
ExecStart=/usr/bin/spawn-fcgi -n \$OPTIONS
KillMode=process
[Install]
WantedBy=multi-user.target
EOF
```

### Проверяю

```console
$ systemctl start spawn-fcgi
$ systemctl status spawn-fcgi
```

![](/images/lesson7/Screenshot_20190527_012506.png)

## Дополнить юнит-файл apache httpd возможностью запустить несколько инстансов сервера с разными конфигами

### Изменяю юнит файл

```console
$ cat > /lib/systemd/system/httpd@.service << EOF
[Unit]
Description=The Apache HTTP Server
After=network.target remote-fs.target nss-lookup.target
Documentation=man:httpd(8)
Documentation=man:apachectl(8)
[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/httpd-%I
ExecStart=/usr/sbin/httpd \$OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd \$OPTIONS -k graceful
ExecStop=/bin/kill -WINCH \${MAINPID}
KillSignal=SIGCONT
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF
```

### Создаю файлы с перемеными окружения

```console
$ cat > /etc/sysconfig/httpd-first << EOF
OPTIONS=-f conf/first.conf
EOF
```

```console
$ cat > /etc/sysconfig/httpd-second << EOF
OPTIONS=-f conf/second.conf
EOF
```

### Копирую кофигурационные файлы

```console
$ cd /etc/httpd/conf/
$ cp httpd.conf first.conf
$ cp httpd.conf second.conf
```

### Правлю второй файл /etc/httpd/conf/second.conf

```
PidFile /var/run/httpd-second.pid
Listen 8080
```

### Запускаю 

```console
$ systemctl start httpd@first
$ systemctl start httpd@second
```

### Проверяю

```console
$ ss -tnulp | grep httpd
```

![](/images/lesson7/Screenshot_20190527_200203.png)
