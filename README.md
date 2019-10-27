
## Домашнее задание к уроку 17

    Домашнее задание 17
    разворачиваем сетевую лабораторию

    # otus-linux
    Vagrantfile - для стенда урока 9 - Network

    # Дано
    https://github.com/erlong15/otus-linux/tree/network
    (ветка network)

    Vagrantfile с начальным построением сети
    - inetRouter
    - centralRouter
    - centralServer

    тестировалось на virtualbox

    # Планируемая архитектура
    построить следующую архитектуру

    Сеть office1
    - 192.168.2.0/26 - dev
    - 192.168.2.64/26 - test servers
    - 192.168.2.128/26 - managers
    - 192.168.2.192/26 - office hardware

    Сеть office2
    - 192.168.1.0/25 - dev
    - 192.168.1.128/26 - test servers
    - 192.168.1.192/26 - office hardware


    Сеть central
    - 192.168.0.0/28 - directors
    - 192.168.0.32/28 - office hardware
    - 192.168.0.64/26 - wifi

    ```
    Office1 ---\
    -----> Central --IRouter --> internet
    Office2----/
    ```
    Итого должны получится следующие сервера
    - inetRouter
    - centralRouter
    - office1Router
    - office2Router
    - centralServer
    - office1Server
    - office2Server

    # Теоретическая часть
    - Найти свободные подсети
    - Посчитать сколько узлов в каждой подсети, включая свободные
    - Указать broadcast адрес для каждой подсети
    - проверить нет ли ошибок при разбиении

    # Практическая часть
    - Соединить офисы в сеть согласно схеме и настроить роутинг
    - Все сервера и роутеры должны ходить в инет черз inetRouter
    - Все сервера должны видеть друг друга
    - у всех новых серверов отключить дефолт на нат (eth0), который вагрант поднимает для связи
    - при нехватке сетевых интервейсов добавить по несколько адресов на интерфейс

```console
$ vagrant up
```

### Диаграмма

![](/images/diagram.png)

### Расчет сети

* Сеть office1
- 192.168.2.0/26 - dev

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.2.0 11000000.10101000.00000010.00   000000
    Маска подсети:  255.255.255.192 = 26    11111111.11111111.11111111.11   000000
    Wildcard:   0.0.0.63    00000000.00000000.00000000.00   111111
    Адрес сети: 192.168.2.0 11000000.10101000.00000010.00   000000 Класс C
    Broadcast:  192.168.2.63    11000000.10101000.00000010.00   111111
    Первый хост:    192.168.2.1 11000000.10101000.00000010.00   000001
    Последний хост: 192.168.2.62    11000000.10101000.00000010.00   111110
    Хостов/Сетей:   62  Приватное адресное пространство (см. RFC-1918)
```


- 192.168.2.64/26 - test servers

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.2.64    11000000.10101000.00000010.01   000000
    Маска подсети:  255.255.255.192 = 26    11111111.11111111.11111111.11   000000
    Wildcard:   0.0.0.63    00000000.00000000.00000000.00   111111
    Адрес сети: 192.168.2.64    11000000.10101000.00000010.01   000000 Класс C
    Broadcast:  192.168.2.127   11000000.10101000.00000010.01   111111
    Первый хост:    192.168.2.65    11000000.10101000.00000010.01   000001
    Последний хост: 192.168.2.126   11000000.10101000.00000010.01   111110
    Хостов/Сетей:   62  Приватное адресное пространство (см. RFC-1918)
```


- 192.168.2.128/26 - managers

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.2.128   11000000.10101000.00000010.10   000000
    Маска подсети:  255.255.255.192 = 26    11111111.11111111.11111111.11   000000
    Wildcard:   0.0.0.63    00000000.00000000.00000000.00   111111
    Адрес сети: 192.168.2.128   11000000.10101000.00000010.10   000000 Класс C
    Broadcast:  192.168.2.191   11000000.10101000.00000010.10   111111
    Первый хост:    192.168.2.129   11000000.10101000.00000010.10   000001
    Последний хост: 192.168.2.190   11000000.10101000.00000010.10   111110
    Хостов/Сетей:   62  Приватное адресное пространство (см. RFC-1918)
```


- 192.168.2.192/26 - office hardware

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.2.192   11000000.10101000.00000010.11   000000
    Маска подсети:  255.255.255.192 = 26    11111111.11111111.11111111.11   000000
    Wildcard:   0.0.0.63    00000000.00000000.00000000.00   111111
    Адрес сети: 192.168.2.192   11000000.10101000.00000010.11   000000 Класс C
    Broadcast:  192.168.2.255   11000000.10101000.00000010.11   111111
    Первый хост:    192.168.2.193   11000000.10101000.00000010.11   000001
    Последний хост: 192.168.2.254   11000000.10101000.00000010.11   111110
    Хостов/Сетей:   62  Приватное адресное пространство (см. RFC-1918)
```


* Сеть office2
- 192.168.1.0/25 - dev

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.1.0 11000000.10101000.00000001.0   0000000
    Маска подсети:  255.255.255.128 = 25    11111111.11111111.11111111.1   0000000
    Wildcard:   0.0.0.127   00000000.00000000.00000000.0   1111111
    Адрес сети: 192.168.1.0 11000000.10101000.00000001.0   0000000 Класс C
    Broadcast:  192.168.1.127   11000000.10101000.00000001.0   1111111
    Первый хост:    192.168.1.1 11000000.10101000.00000001.0   0000001
    Последний хост: 192.168.1.126   11000000.10101000.00000001.0   1111110
    Хостов/Сетей:   126 Приватное адресное пространство (см. RFC-1918)
```
   

- 192.168.1.128/26 - test servers

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.1.128   11000000.10101000.00000001.10   000000
    Маска подсети:  255.255.255.192 = 26    11111111.11111111.11111111.11   000000
    Wildcard:   0.0.0.63    00000000.00000000.00000000.00   111111
    Адрес сети: 192.168.1.128   11000000.10101000.00000001.10   000000 Класс C
    Broadcast:  192.168.1.191   11000000.10101000.00000001.10   111111
    Первый хост:    192.168.1.129   11000000.10101000.00000001.10   000001
    Последний хост: 192.168.1.190   11000000.10101000.00000001.10   111110
    Хостов/Сетей:   62  Приватное адресное пространство (см. RFC-1918)
```


- 192.168.1.192/26 - office hardware

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.1.192   11000000.10101000.00000001.11   000000
    Маска подсети:  255.255.255.192 = 26    11111111.11111111.11111111.11   000000
    Wildcard:   0.0.0.63    00000000.00000000.00000000.00   111111
    Адрес сети: 192.168.1.192   11000000.10101000.00000001.11   000000 Класс C
    Broadcast:  192.168.1.255   11000000.10101000.00000001.11   111111
    Первый хост:    192.168.1.193   11000000.10101000.00000001.11   000001
    Последний хост: 192.168.1.254   11000000.10101000.00000001.11   111110
    Хостов/Сетей:   62  Приватное адресное пространство (см. RFC-1918)
```


* Сеть central
- 192.168.0.0/28 - directors

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.0.0 11000000.10101000.00000000.0000   0000
    Маска подсети:  255.255.255.240 = 28    11111111.11111111.11111111.1111   0000
    Wildcard:   0.0.0.15    00000000.00000000.00000000.0000   1111
    Адрес сети: 192.168.0.0 11000000.10101000.00000000.0000   0000 Класс C
    Broadcast:  192.168.0.15    11000000.10101000.00000000.0000   1111
    Первый хост:    192.168.0.1 11000000.10101000.00000000.0000   0001
    Последний хост: 192.168.0.14    11000000.10101000.00000000.0000   1110
    Хостов/Сетей:   14  Приватное адресное пространство (см. RFC-1918)
```


- 192.168.0.32/28 - office hardware

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.0.32    11000000.10101000.00000000.0010   0000
    Маска подсети:  255.255.255.240 = 28    11111111.11111111.11111111.1111   0000
    Wildcard:   0.0.0.15    00000000.00000000.00000000.0000   1111
    Адрес сети: 192.168.0.32    11000000.10101000.00000000.0010   0000 Класс C
    Broadcast:  192.168.0.47    11000000.10101000.00000000.0010   1111
    Первый хост:    192.168.0.33    11000000.10101000.00000000.0010   0001
    Последний хост: 192.168.0.46    11000000.10101000.00000000.0010   1110
    Хостов/Сетей:   14  Приватное адресное пространство (см. RFC-1918)
```
   

- 192.168.0.64/26 - wifi

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.0.64    11000000.10101000.00000000.01   000000
    Маска подсети:  255.255.255.192 = 26    11111111.11111111.11111111.11   000000
    Wildcard:   0.0.0.63    00000000.00000000.00000000.00   111111
    Адрес сети: 192.168.0.64    11000000.10101000.00000000.01   000000 Класс C
    Broadcast:  192.168.0.127   11000000.10101000.00000000.01   111111
    Первый хост:    192.168.0.65    11000000.10101000.00000000.01   000001
    Последний хост: 192.168.0.126   11000000.10101000.00000000.01   111110
    Хостов/Сетей:   62  Приватное адресное пространство (см. RFC-1918)
```
       

* Сеть router-net
- 192.168.255.0/30

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.255.0   11000000.10101000.11111111.000000   00
    Маска подсети:  255.255.255.252 = 30    11111111.11111111.11111111.111111   00
    Wildcard:   0.0.0.3 00000000.00000000.00000000.000000   11
    Адрес сети: 192.168.255.0   11000000.10101000.11111111.000000   00 Класс C
    Broadcast:  192.168.255.3   11000000.10101000.11111111.000000   11
    Первый хост:    192.168.255.1   11000000.10101000.11111111.000000   01
    Последний хост: 192.168.255.2   11000000.10101000.11111111.000000   10
    Хостов/Сетей:   2   Приватное адресное пространство (см. RFC-1918)
```


* Сеть central-net
- 192.168.255.8/29

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.255.8   11000000.10101000.11111111.00001   000
    Маска подсети:  255.255.255.248 = 29    11111111.11111111.11111111.11111   000
    Wildcard:   0.0.0.7 00000000.00000000.00000000.00000   111
    Адрес сети: 192.168.255.8   11000000.10101000.11111111.00001   000 Класс C
    Broadcast:  192.168.255.15  11000000.10101000.11111111.00001   111
    Первый хост:    192.168.255.9   11000000.10101000.11111111.00001   001
    Последний хост: 192.168.255.14  11000000.10101000.11111111.00001   110
    Хостов/Сетей:   6   Приватное адресное пространство (см. RFC-1918)
```


### Свободные подсети

* Сеть **192.168.0.0/24**

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.0.0 11000000.10101000.00000000.   00000000
    Маска подсети:  255.255.255.0 = 24  11111111.11111111.11111111.   00000000
    Wildcard:   0.0.0.255   00000000.00000000.00000000.   11111111
    Адрес сети: 192.168.0.0 11000000.10101000.00000000.   00000000 Класс C
    Broadcast:  192.168.0.255   11000000.10101000.00000000.   11111111
    Первый хост:    192.168.0.1 11000000.10101000.00000000.   00000001
    Последний хост: 192.168.0.254   11000000.10101000.00000000.   11111110
    Хостов/Сетей:   254 Приватное адресное пространство (см. RFC-1918)
```


- 192.168.0.16/28

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.0.16    11000000.10101000.00000000.0001   0000
    Маска подсети:  255.255.255.240 = 28    11111111.11111111.11111111.1111   0000
    Wildcard:   0.0.0.15    00000000.00000000.00000000.0000   1111
    Адрес сети: 192.168.0.16    11000000.10101000.00000000.0001   0000 Класс C
    Broadcast:  192.168.0.31    11000000.10101000.00000000.0001   1111
    Первый хост:    192.168.0.17    11000000.10101000.00000000.0001   0001
    Последний хост: 192.168.0.30    11000000.10101000.00000000.0001   1110
    Хостов/Сетей:   14  Приватное адресное пространство (см. RFC-1918)
```


- 192.168.0.48/28

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.0.48    11000000.10101000.00000000.0011   0000
    Маска подсети:  255.255.255.240 = 28    11111111.11111111.11111111.1111   0000
    Wildcard:   0.0.0.15    00000000.00000000.00000000.0000   1111
    Адрес сети: 192.168.0.48    11000000.10101000.00000000.0011   0000 Класс C
    Broadcast:  192.168.0.63    11000000.10101000.00000000.0011   1111
    Первый хост:    192.168.0.49    11000000.10101000.00000000.0011   0001
    Последний хост: 192.168.0.62    11000000.10101000.00000000.0011   1110
    Хостов/Сетей:   14  Приватное адресное пространство (см. RFC-1918)
```
   

- 192.168.0.128/25

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.0.128   11000000.10101000.00000000.1   0000000
    Маска подсети:  255.255.255.128 = 25    11111111.11111111.11111111.1   0000000
    Wildcard:   0.0.0.127   00000000.00000000.00000000.0   1111111
    Адрес сети: 192.168.0.128   11000000.10101000.00000000.1   0000000 Класс C
    Broadcast:  192.168.0.255   11000000.10101000.00000000.1   1111111
    Первый хост:    192.168.0.129   11000000.10101000.00000000.1   0000001
    Последний хост: 192.168.0.254   11000000.10101000.00000000.1   1111110
    Хостов/Сетей:   126 Приватное адресное пространство (см. RFC-1918)
```


* Сеть **192.168.255.0/24**

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.255.0   11000000.10101000.11111111.   00000000
    Маска подсети:  255.255.255.0 = 24  11111111.11111111.11111111.   00000000
    Wildcard:   0.0.0.255   00000000.00000000.00000000.   11111111
    Адрес сети: 192.168.255.0   11000000.10101000.11111111.   00000000 Класс C
    Broadcast:  192.168.255.255 11000000.10101000.11111111.   11111111
    Первый хост:    192.168.255.1   11000000.10101000.11111111.   00000001
    Последний хост: 192.168.255.254 11000000.10101000.11111111.   11111110
    Хостов/Сетей:   254 Приватное адресное пространство (см. RFC-1918)
```


- 192.168.255.4/30

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.255.4   11000000.10101000.11111111.000001   00
    Маска подсети:  255.255.255.252 = 30    11111111.11111111.11111111.111111   00
    Wildcard:   0.0.0.3 00000000.00000000.00000000.000000   11
    Адрес сети: 192.168.255.4   11000000.10101000.11111111.000001   00 Класс C
    Broadcast:  192.168.255.7   11000000.10101000.11111111.000001   11
    Первый хост:    192.168.255.5   11000000.10101000.11111111.000001   01
    Последний хост: 192.168.255.6   11000000.10101000.11111111.000001   10
    Хостов/Сетей:   2   Приватное адресное пространство (см. RFC-1918)
```
    

- 192.168.255.16/28

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.255.16  11000000.10101000.11111111.0001   0000
    Маска подсети:  255.255.255.240 = 28    11111111.11111111.11111111.1111   0000
    Wildcard:   0.0.0.15    00000000.00000000.00000000.0000   1111
    Адрес сети: 192.168.255.16  11000000.10101000.11111111.0001   0000 Класс C
    Broadcast:  192.168.255.31  11000000.10101000.11111111.0001   1111
    Первый хост:    192.168.255.17  11000000.10101000.11111111.0001   0001
    Последний хост: 192.168.255.30  11000000.10101000.11111111.0001   1110
    Хостов/Сетей:   14  Приватное адресное пространство (см. RFC-1918)
```


- 192.168.255.32/27

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.255.32  11000000.10101000.11111111.001   00000
    Маска подсети:  255.255.255.224 = 27    11111111.11111111.11111111.111   00000
    Wildcard:   0.0.0.31    00000000.00000000.00000000.000   11111
    Адрес сети: 192.168.255.32  11000000.10101000.11111111.001   00000 Класс C
    Broadcast:  192.168.255.63  11000000.10101000.11111111.001   11111
    Первый хост:    192.168.255.33  11000000.10101000.11111111.001   00001
    Последний хост: 192.168.255.62  11000000.10101000.11111111.001   11110
    Хостов/Сетей:   30  Приватное адресное пространство (см. RFC-1918)
```


- 192.168.255.64/26

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.255.64  11000000.10101000.11111111.01   000000
    Маска подсети:  255.255.255.192 = 26    11111111.11111111.11111111.11   000000
    Wildcard:   0.0.0.63    00000000.00000000.00000000.00   111111
    Адрес сети: 192.168.255.64  11000000.10101000.11111111.01   000000 Класс C
    Broadcast:  192.168.255.127 11000000.10101000.11111111.01   111111
    Первый хост:    192.168.255.65  11000000.10101000.11111111.01   000001
    Последний хост: 192.168.255.126 11000000.10101000.11111111.01   111110
    Хостов/Сетей:   62  Приватное адресное пространство (см. RFC-1918)
```


- 192.168.255.128/25

```
    Десятичный  Двоичный     
    IP-адрес:   192.168.255.128 11000000.10101000.11111111.1   0000000
    Маска подсети:  255.255.255.128 = 25    11111111.11111111.11111111.1   0000000
    Wildcard:   0.0.0.127   00000000.00000000.00000000.0   1111111
    Адрес сети: 192.168.255.128 11000000.10101000.11111111.1   0000000 Класс C
    Broadcast:  192.168.255.255 11000000.10101000.11111111.1   1111111
    Первый хост:    192.168.255.129 11000000.10101000.11111111.1   0000001
    Последний хост: 192.168.255.254 11000000.10101000.11111111.1   1111110
    Хостов/Сетей:   126 Приватное адресное пространство (см. RFC-1918)
```
   