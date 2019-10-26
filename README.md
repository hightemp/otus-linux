
## Домашнее задание к уроку 22

    Домашнее задание 22
    строим бонды и вланы
    в Office1 в тестовой подсети появляется сервера с доп интерфесами и адресами
    в internal сети testLAN
    - testClient1 - 10.10.10.254
    - testClient2 - 10.10.10.254
    - testServer1- 10.10.10.1
    - testServer2- 10.10.10.1

    равести вланами
    testClient1 <-> testServer1
    testClient2 <-> testServer2

    между centralRouter и inetRouter
    "пробросить" 2 линка (общая inernal сеть) и объединить их в бонд
    проверить работу c отключением интерфейсов

    для сдачи - вагрант файл с требуемой конфигурацией
    Разворачиваться конфигурация должна через ансибл

```console
$ vagrant up
```

### Проверка портов

```console
$ ss -ltn
```

### Удаляем eth0
```console
$ . test.sh
```

### Проверка
```console
$ . test2.sh
Pseudo-terminal will not be allocated because stdin is not a terminal.
Warning: Permanently added '[127.0.0.1]:8001' (ECDSA) to the list of known hosts.
***** hightemp-computer-01 *****
>> ip route <<
default via 192.168.255.1 dev bond0 proto static metric 300 
192.168.0.0/28 dev eth3 proto kernel scope link src 192.168.0.1 metric 103 
192.168.0.32/28 dev eth4 proto kernel scope link src 192.168.0.33 metric 104 
192.168.0.64/26 dev eth5 proto kernel scope link src 192.168.0.65 metric 105 
192.168.1.0/24 via 192.168.255.11 dev eth6 proto static metric 106 
192.168.2.0/24 via 192.168.255.10 dev eth6 proto static metric 106 
192.168.255.0/30 dev bond0 proto kernel scope link src 192.168.255.2 metric 300 
192.168.255.8/29 dev eth6 proto kernel scope link src 192.168.255.9 metric 106 
>> tracepath -n 10.10.10.1 <<
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.255.1                                         1.077ms 
 1:  192.168.255.1                                         0.365ms 
 2:  10.0.2.2                                              0.538ms 
 3:  no reply
 4:  10.136.0.1                                           57.894ms asymm 64 
 5:  10.109.11.6                                          22.418ms asymm 63 
     Too many hops: pmtu 1500
     Resume: pmtu 1500 
>> ping 10.10.10.1 <<
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.

--- 10.10.10.1 ping statistics ---
5 packets transmitted, 0 received, 100% packet loss, time 4000ms

>> tracepath -n 10.10.10.254 <<
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.255.1                                         0.495ms 
 1:  192.168.255.1                                         0.358ms 
 2:  10.0.2.2                                              0.408ms 
 3:  no reply
 4:  10.136.0.1                                            5.439ms asymm 64 
 5:  10.109.11.6                                          13.336ms asymm 63 
     Too many hops: pmtu 1500
     Resume: pmtu 1500 
>> ping 10.10.10.254 <<
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.

--- 10.10.10.254 ping statistics ---
5 packets transmitted, 0 received, 100% packet loss, time 4000ms

>> ping 8.8.8.8 <<
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=61 time=21.6 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=61 time=21.6 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=61 time=50.9 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=61 time=22.5 ms
64 bytes from 8.8.8.8: icmp_seq=5 ttl=61 time=28.0 ms

--- 8.8.8.8 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4008ms
rtt min/avg/max/mdev = 21.615/28.948/50.905/11.233 ms



Pseudo-terminal will not be allocated because stdin is not a terminal.
Warning: Permanently added '[127.0.0.1]:8002' (ECDSA) to the list of known hosts.
***** hightemp-computer-01 *****
>> ip route <<
default via 192.168.0.1 dev eth1 proto static metric 100 
192.168.0.0/28 dev eth1 proto kernel scope link src 192.168.0.2 metric 100 
>> tracepath -n 10.10.10.1 <<
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.0.1                                           1.013ms 
 1:  192.168.0.1                                           0.363ms 
 2:  192.168.255.1                                         0.633ms 
 3:  10.0.2.2                                              0.991ms 
 4:  no reply
 5:  no reply
     Too many hops: pmtu 1500
     Resume: pmtu 1500 
>> ping 10.10.10.1 <<
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.

--- 10.10.10.1 ping statistics ---
5 packets transmitted, 0 received, 100% packet loss, time 4006ms

>> tracepath -n 10.10.10.254 <<
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.0.1                                           0.532ms 
 1:  192.168.0.1                                           0.311ms 
 2:  192.168.255.1                                         0.733ms 
 3:  10.0.2.2                                              0.822ms 
 4:  no reply
 5:  no reply
     Too many hops: pmtu 1500
     Resume: pmtu 1500 
>> ping 10.10.10.254 <<
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.

--- 10.10.10.254 ping statistics ---
5 packets transmitted, 0 received, 100% packet loss, time 4003ms

>> ping 8.8.8.8 <<
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=59 time=22.6 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=59 time=22.2 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=59 time=24.4 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=59 time=21.8 ms
64 bytes from 8.8.8.8: icmp_seq=5 ttl=59 time=23.8 ms

--- 8.8.8.8 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4008ms
rtt min/avg/max/mdev = 21.899/23.029/24.429/0.967 ms



Pseudo-terminal will not be allocated because stdin is not a terminal.
Warning: Permanently added '[127.0.0.1]:8003' (ECDSA) to the list of known hosts.
***** hightemp-computer-01 *****
>> ip route <<
default via 192.168.255.9 dev eth1 proto static metric 106 
192.168.2.0/26 dev eth2 proto kernel scope link src 192.168.2.1 metric 102 
192.168.2.64/26 dev eth3 proto kernel scope link src 192.168.2.65 metric 103 
192.168.2.128/26 dev eth4 proto kernel scope link src 192.168.2.129 metric 104 
192.168.2.192/26 dev eth5 proto kernel scope link src 192.168.2.193 metric 105 
192.168.255.8/29 dev eth1 proto kernel scope link src 192.168.255.10 metric 106 
>> tracepath -n 10.10.10.1 <<
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.255.9                                         0.350ms 
 1:  192.168.255.9                                         0.352ms 
 2:  192.168.255.1                                         0.761ms 
 3:  10.0.2.2                                              1.013ms 
 4:  no reply
 5:  no reply
     Too many hops: pmtu 1500
     Resume: pmtu 1500 
>> ping 10.10.10.1 <<
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.

--- 10.10.10.1 ping statistics ---
5 packets transmitted, 0 received, 100% packet loss, time 4006ms

>> tracepath -n 10.10.10.254 <<
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.255.9                                         0.391ms 
 1:  192.168.255.9                                         0.287ms 
 2:  192.168.255.1                                         0.700ms 
 3:  10.0.2.2                                              0.786ms 
 4:  no reply
 5:  no reply
     Too many hops: pmtu 1500
     Resume: pmtu 1500 
>> ping 10.10.10.254 <<
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.

--- 10.10.10.254 ping statistics ---
5 packets transmitted, 0 received, 100% packet loss, time 4007ms

>> ping 8.8.8.8 <<
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=59 time=21.9 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=59 time=21.4 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=59 time=21.6 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=59 time=21.4 ms
64 bytes from 8.8.8.8: icmp_seq=5 ttl=59 time=21.6 ms

--- 8.8.8.8 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4008ms
rtt min/avg/max/mdev = 21.407/21.635/21.998/0.225 ms



Pseudo-terminal will not be allocated because stdin is not a terminal.
channel 2: open failed: connect failed: No route to host
ssh_exchange_identification: read: Connection reset by peer
Pseudo-terminal will not be allocated because stdin is not a terminal.
Warning: Permanently added '[127.0.0.1]:8005' (ECDSA) to the list of known hosts.
***** hightemp-computer-01 *****
>> ip route <<
default via 192.168.255.9 dev eth1 proto static metric 105 
192.168.1.0/25 dev eth2 proto kernel scope link src 192.168.1.1 metric 102 
192.168.1.128/26 dev eth3 proto kernel scope link src 192.168.1.129 metric 103 
192.168.1.192/26 dev eth4 proto kernel scope link src 192.168.1.193 metric 104 
192.168.255.8/29 dev eth1 proto kernel scope link src 192.168.255.11 metric 105 
>> tracepath -n 10.10.10.1 <<
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.255.9                                         0.364ms 
 1:  192.168.255.9                                         0.224ms 
 2:  192.168.255.1                                         0.489ms 
 3:  10.0.2.2                                              0.658ms 
 4:  no reply
 5:  no reply
     Too many hops: pmtu 1500
     Resume: pmtu 1500 
>> ping 10.10.10.1 <<
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.

--- 10.10.10.1 ping statistics ---
5 packets transmitted, 0 received, 100% packet loss, time 4013ms

>> tracepath -n 10.10.10.254 <<
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.255.9                                         0.635ms 
 1:  192.168.255.9                                         0.759ms 
 2:  192.168.255.1                                         1.156ms 
 3:  10.0.2.2                                              1.249ms 
 4:  no reply
 5:  no reply
     Too many hops: pmtu 1500
     Resume: pmtu 1500 
>> ping 10.10.10.254 <<
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.

--- 10.10.10.254 ping statistics ---
5 packets transmitted, 0 received, 100% packet loss, time 4000ms

>> ping 8.8.8.8 <<
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=59 time=22.6 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=59 time=22.3 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=59 time=22.3 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=59 time=22.7 ms
64 bytes from 8.8.8.8: icmp_seq=5 ttl=59 time=21.9 ms

--- 8.8.8.8 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4010ms
rtt min/avg/max/mdev = 21.928/22.403/22.788/0.339 ms



Pseudo-terminal will not be allocated because stdin is not a terminal.
Warning: Permanently added '[127.0.0.1]:8006' (ECDSA) to the list of known hosts.
***** hightemp-computer-01 *****
>> ip route <<
default via 192.168.1.1 dev eth1 proto static metric 101 
192.168.1.0/26 dev eth1 proto kernel scope link src 192.168.1.2 metric 101 
>> tracepath -n 10.10.10.1 <<
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.1.1                                           0.349ms 
 1:  192.168.1.1                                           0.265ms 
 2:  192.168.255.9                                         0.634ms 
 3:  192.168.255.1                                         0.938ms 
 4:  10.0.2.2                                              1.013ms 
 5:  no reply
     Too many hops: pmtu 1500
     Resume: pmtu 1500 
>> ping 10.10.10.1 <<
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.

--- 10.10.10.1 ping statistics ---
5 packets transmitted, 0 received, 100% packet loss, time 3999ms

>> tracepath -n 10.10.10.254 <<
 1?: [LOCALHOST]                                         pmtu 1500
 1:  192.168.1.1                                           0.494ms 
 1:  192.168.1.1                                           0.366ms 
 2:  192.168.255.9                                         1.044ms 
 3:  192.168.255.1                                         1.352ms 
 4:  10.0.2.2                                              1.478ms 
 5:  no reply
     Too many hops: pmtu 1500
     Resume: pmtu 1500 
>> ping 10.10.10.254 <<
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.

--- 10.10.10.254 ping statistics ---
5 packets transmitted, 0 received, 100% packet loss, time 4005ms

>> ping 8.8.8.8 <<
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=57 time=22.9 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=57 time=23.3 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=57 time=25.0 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=57 time=22.9 ms
64 bytes from 8.8.8.8: icmp_seq=5 ttl=57 time=22.1 ms

--- 8.8.8.8 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4006ms
rtt min/avg/max/mdev = 22.105/23.256/25.023/0.978 ms



Pseudo-terminal will not be allocated because stdin is not a terminal.
Warning: Permanently added '[127.0.0.1]:8007' (ECDSA) to the list of known hosts.
***** hightemp-computer-01 *****
>> ip route <<
default via 192.168.2.65 dev eth1 proto static metric 100 
10.10.10.0/24 dev eth1.2 proto kernel scope link src 10.10.10.1 metric 400 
192.168.2.64/26 dev eth1 proto kernel scope link src 192.168.2.66 metric 100 
>> tracepath -n 10.10.10.1 <<
 1:  10.10.10.1                                            0.077ms reached
     Resume: pmtu 65535 hops 1 back 1 
>> ping 10.10.10.1 <<
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=0.017 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=0.062 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=0.072 ms
64 bytes from 10.10.10.1: icmp_seq=4 ttl=64 time=0.056 ms
64 bytes from 10.10.10.1: icmp_seq=5 ttl=64 time=0.067 ms

--- 10.10.10.1 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4003ms
rtt min/avg/max/mdev = 0.017/0.054/0.072/0.021 ms
>> tracepath -n 10.10.10.254 <<
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.10.10.254                                          0.428ms reached
 1:  10.10.10.254                                          0.247ms reached
     Resume: pmtu 1500 hops 1 back 1 
>> ping 10.10.10.254 <<
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=0.289 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=0.550 ms
64 bytes from 10.10.10.254: icmp_seq=3 ttl=64 time=0.670 ms
64 bytes from 10.10.10.254: icmp_seq=4 ttl=64 time=0.601 ms
64 bytes from 10.10.10.254: icmp_seq=5 ttl=64 time=0.751 ms

--- 10.10.10.254 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4003ms
rtt min/avg/max/mdev = 0.289/0.572/0.751/0.157 ms
>> ping 8.8.8.8 <<
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=57 time=77.2 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=57 time=73.8 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=57 time=71.4 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=57 time=22.8 ms
64 bytes from 8.8.8.8: icmp_seq=5 ttl=57 time=72.9 ms

--- 8.8.8.8 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4005ms
rtt min/avg/max/mdev = 22.893/63.676/77.251/20.483 ms



Pseudo-terminal will not be allocated because stdin is not a terminal.
Warning: Permanently added '[127.0.0.1]:8008' (ECDSA) to the list of known hosts.
***** hightemp-computer-01 *****
>> ip route <<
default via 192.168.2.1 dev eth1 proto static metric 101 
10.10.10.0/24 dev eth1.2 proto kernel scope link src 10.10.10.254 metric 400 
192.168.2.0/26 dev eth1 proto kernel scope link src 192.168.2.3 metric 101 
>> tracepath -n 10.10.10.1 <<
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.10.10.1                                            0.451ms reached
 1:  10.10.10.1                                            0.243ms reached
     Resume: pmtu 1500 hops 1 back 1 
>> ping 10.10.10.1 <<
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=0.308 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=0.526 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=0.721 ms
64 bytes from 10.10.10.1: icmp_seq=4 ttl=64 time=0.721 ms
64 bytes from 10.10.10.1: icmp_seq=5 ttl=64 time=0.717 ms

--- 10.10.10.1 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4004ms
rtt min/avg/max/mdev = 0.308/0.598/0.721/0.165 ms
>> tracepath -n 10.10.10.254 <<
 1:  10.10.10.254                                          0.100ms reached
     Resume: pmtu 65535 hops 1 back 1 
>> ping 10.10.10.254 <<
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=0.017 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=0.050 ms
64 bytes from 10.10.10.254: icmp_seq=3 ttl=64 time=0.071 ms
64 bytes from 10.10.10.254: icmp_seq=4 ttl=64 time=0.060 ms
64 bytes from 10.10.10.254: icmp_seq=5 ttl=64 time=0.070 ms

--- 10.10.10.254 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 3997ms
rtt min/avg/max/mdev = 0.017/0.053/0.071/0.021 ms
>> ping 8.8.8.8 <<
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=57 time=22.3 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=57 time=41.8 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=57 time=23.9 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=57 time=43.6 ms
64 bytes from 8.8.8.8: icmp_seq=5 ttl=57 time=22.3 ms

--- 8.8.8.8 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4007ms
rtt min/avg/max/mdev = 22.354/30.839/43.672/9.756 ms



Pseudo-terminal will not be allocated because stdin is not a terminal.
ssh: connect to host 127.0.0.1 port 8009: Connection refused
Pseudo-terminal will not be allocated because stdin is not a terminal.
Warning: Permanently added '[127.0.0.1]:8010' (ECDSA) to the list of known hosts.
***** hightemp-computer-01 *****
>> ip route <<
default via 192.168.2.1 dev eth1 proto static metric 101 
10.10.10.0/24 dev eth1.3 proto kernel scope link src 10.10.10.254 metric 400 
192.168.2.0/26 dev eth1 proto kernel scope link src 192.168.2.4 metric 101 
>> tracepath -n 10.10.10.1 <<
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.10.10.1                                            0.431ms reached
 1:  10.10.10.1                                            0.264ms reached
     Resume: pmtu 1500 hops 1 back 1 
>> ping 10.10.10.1 <<
PING 10.10.10.1 (10.10.10.1) 56(84) bytes of data.
64 bytes from 10.10.10.1: icmp_seq=1 ttl=64 time=0.370 ms
64 bytes from 10.10.10.1: icmp_seq=2 ttl=64 time=0.481 ms
64 bytes from 10.10.10.1: icmp_seq=3 ttl=64 time=0.416 ms
64 bytes from 10.10.10.1: icmp_seq=4 ttl=64 time=0.500 ms
64 bytes from 10.10.10.1: icmp_seq=5 ttl=64 time=0.503 ms

--- 10.10.10.1 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4003ms
rtt min/avg/max/mdev = 0.370/0.454/0.503/0.052 ms
>> tracepath -n 10.10.10.254 <<
 1:  10.10.10.254                                          0.076ms reached
     Resume: pmtu 65535 hops 1 back 1 
>> ping 10.10.10.254 <<
PING 10.10.10.254 (10.10.10.254) 56(84) bytes of data.
64 bytes from 10.10.10.254: icmp_seq=1 ttl=64 time=0.016 ms
64 bytes from 10.10.10.254: icmp_seq=2 ttl=64 time=0.040 ms
64 bytes from 10.10.10.254: icmp_seq=3 ttl=64 time=0.048 ms
64 bytes from 10.10.10.254: icmp_seq=4 ttl=64 time=0.048 ms
64 bytes from 10.10.10.254: icmp_seq=5 ttl=64 time=0.059 ms

--- 10.10.10.254 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 3998ms
rtt min/avg/max/mdev = 0.016/0.042/0.059/0.015 ms
>> ping 8.8.8.8 <<
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=57 time=21.9 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=57 time=21.9 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=57 time=22.6 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=57 time=22.1 ms
64 bytes from 8.8.8.8: icmp_seq=5 ttl=57 time=23.3 ms

--- 8.8.8.8 ping statistics ---
5 packets transmitted, 5 received, 0% packet loss, time 4007ms
rtt min/avg/max/mdev = 21.957/22.416/23.383/0.542 ms
```