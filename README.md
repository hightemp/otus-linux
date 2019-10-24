
## Домашнее задание к уроку 14

```console
$ vagrant up
```

### Проверяю отправку логов nginx

```console
$ vagrant ssh log
$ curl -I 10.0.10.3
$ grep nginx /var/log/messages
$ exit
```

### Проверяю отправку критических ошибок
```console
$ vagrant ssh web
$ logger -p crit TEST
$ exit

$ vagrant ssh log
$ sudo grep web /var/log/messages
$ exit
```

![](/images/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202019-10-24%2012-27-05.png)

### Проверяю аудит
```console
$ vagrant ssh web
$ sudo sh -c 'echo "# TEST" >> /etc/nginx/nginx.conf'
$ sudo ausearch -k nginx_conf
$ exit

$ vagrant ssh log
$ sudo ausearch -k nginx_conf
$ exit
```
![](/images/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202019-10-24%2012-30-16.png)
![](/images/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202019-10-24%2012-31-10.png)
