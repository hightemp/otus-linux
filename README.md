## Домашнее задание 23

    Простая защита от DDOS
    Цель: Разобраться в базовых принципах конфигурирования nginx. Рассмотреть хорошие\плохие практики конфигурирования, настройки ssl.
    https://gitlab.com/otus_linux/nginx-antiddos-example

    # Простая защита от ДДОС

    ## Защита от ДДОС средствами nginx
    Написать конфигурацию nginx, которая даёт доступ клиенту только с определенной cookie.
    Если у клиента её нет, нужно выполнить редирект на location, в котором кука будет добавлена, после чего клиент будет обратно отправлен (редирект) на запрашиваемый ресурс.

    Смысл: умные боты попадаются редко, тупые боты по редиректам с куками два раза не пойдут

    Для выполнения ДЗ понадобятся
    * https://nginx.org/ru/docs/http/ngx_http_rewrite_module.html
    * https://nginx.org/ru/docs/http/ngx_http_headers_module.html

    ## Защита от продвинутых ботов связкой nginx + java script (задание со *)

    Защиту из предыдудщего задания можно проверить/преодолеть командой curl -c cookie -b cookie http://localhost/otus.txt -i -L
    Ваша задача написать такую конфигурацию, которая отдает контент клиенту умеющему java script и meta-redirect

    Для выполнения понадобятся:
    * https://www.w3.org/TR/WCAG20-TECHS/H76.html
    * http://nginx.org/en/docs/http/ngx_http_core_module.html#error_page
    * Базовые знания java script 

    ## Инструкции для выполнения и сдачи
    * Необходимо редактировать nginx.conf из этого репозитория (не следует использовать include и править Dockerfile)
    * Cделанную работу нужно залить hub.docker.com, при этом content в otus.txt должен содержать в себе название Вашего репозитория hub.docker.com и только его
    * Базовое задание должно быть в образе с тегом latest, задание для продвинутых в образе с тегом advanced.
    * Самопроверка: docker run -p 80:80 your_account/your_repo:latest (или your_account/your_repo:advanced) - запустит nginx c выполненым заданием. сurl http://localhost/otus.txt - редирект(или ошибка) , открыв ту же страницу в браузере - увидим your_account/your_repo

```console
$ sudo docker run -p 8090:80 hightemp/otus-linux-lesson23:latest
```
### Проверка

```console
$ ./start.sh latest
[!] sudo docker run -p8090:80 ea734f5ef195
172.17.0.1 - - [29/Oct/2019:19:21:42 +0000] "GET /otus.txt HTTP/1.1" 200 66 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:70.0) Gecko/20100101 Firefox/70.0" "-"
172.17.0.1 - - [29/Oct/2019:19:21:50 +0000] "GET /otus.txt?access=1 HTTP/1.1" 200 29 "-" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:70.0) Gecko/20100101 Firefox/70.0" "-"
```

```console
$ curl -I 127.0.0.1:8090/otus.txt
HTTP/1.1 404 Not Found
Server: nginx/1.17.5
Date: Tue, 29 Oct 2019 19:18:06 GMT
Content-Type: text/html
Content-Length: 153
Connection: keep-alive
```