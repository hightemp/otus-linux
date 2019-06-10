
## Домашнее задание к уроку 10

### Создаю Dockerfile

```console
$ cat > Dockerfile <<-EOF
FROM alpine
RUN apk add --no-cache bash
RUN apk add --no-cache nginx
RUN rm /etc/nginx/conf.d/default.conf
COPY default.conf /etc/nginx/conf.d/
COPY index.html /var/www/localhost/htdocs/
RUN mkdir -p /run/nginx
EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
EOF
```

### Собираю

```console
$ sudo docker build -t otus-linux-lesson10 .
```

### Запускаю

```console
$ sudo docker run --name otus-linux-lesson10 -p 80:80 -d otus-linux-lesson10
```

### Вхожу 

```console
$ sudo docker login --username=hightemp
```

### Нахожу образ

```console
$ sudo docker images
```

### Добавляю тэг

```console
$ docker tag f352e5d9e1ee hightemp/otus-linux-lesson10:1.0
```

### Отправляю на сервер

```console
$ sudo docker push hightemp/otus-linux-lesson10
```

https://hub.docker.com/r/hightemp/otus-linux-lesson10

> Определите разницу между контейнером и образом

Образы - это неизменяемые снимки контейнеров, это упорядоченная коллекция изменений корневой файловой системы и соответствующих параметров выполнения для использования во время выполнения контейнера. 
Контейнеры - это запущенные экземпляры образов.

> Вывод опишите в домашнем задании.

Достоиства докера заключаются: в абстрагировании, масштабировании, изоляции среды, использовании слоев, использовании среды.

> Ответьте на вопрос: Можно ли в контейнере собрать ядро?

Да. https://hub.docker.com/r/moul/kernel-builder/
