
## Домашнее задание к уроку 20

    Домашнее задание 20
    настраиваем split-dns
    взять стенд https://github.com/erlong15/vagrant-bind
    добавить еще один сервер client2
    завести в зоне dns.lab
    имена
    web1 - смотрит на клиент1
    web2 смотрит на клиент2

    завести еще одну зону newdns.lab
    завести в ней запись
    www - смотрит на обоих клиентов

    настроить split-dns
    клиент1 - видит обе зоны, но в зоне dns.lab только web1

    клиент2 видит только dns.lab

    *) настроить все без выключения selinux

```console
$ vagrant up
```

### Проверка

```console
$ vagrant ssh client1
$ dig web1.dns.lab
$ dig web2.dns.lab
$ dig www.newdns.lab
$ dig -x 10.0.10.4
$ dig @10.0.10.2 web1.dns.lab
$ dig @10.0.10.2 web2.dns.lab
$ dig @10.0.10.2 www.newdns.lab
$ dig @10.0.10.2 -x 10.0.10.4
```