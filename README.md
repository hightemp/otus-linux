
## Домашнее задание к уроку 18

    Домашнее задание 18
    Сценарии iptables
    1) реализовать knocking port
    - centralRouter может попасть на ssh inetrRouter через knock скрипт
    пример в материалах
    2) добавить inetRouter2, который виден(маршрутизируется (host-only тип сети для виртуалки)) с хоста или форвардится порт через локалхост
    3) запустить nginx на centralServer
    4) пробросить 80й порт на inetRouter2 8080
    5) дефолт в инет оставить через inetRouter


```console
$ . start.sh
```

### Проверка порта

```console
$ curl -I 127.0.0.1:8080
```

### Проверка knock скрипта

```console
$ ssh -i ~/.vagrant.d/insecure_private_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null vagrant@127.0.0.1 -p 8001
$ ssh 192.168.255.1
$ . /vagrant/files/knock.sh open
$ ssh 192.168.255.1
```


