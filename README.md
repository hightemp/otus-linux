
## Домашнее задание к уроку 19

    Домашнее задание 19
    OSPF
    - Поднять три виртуалки
    - Объединить их разными vlan
    1. Поднять OSPF между машинами на базе Quagga
    2. Изобразить ассиметричный роутинг
    3. Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным

### Поднять OSPF между машинами на базе Quagga

```console
$ TASK=1 vagrant up
```

<details>
<summary><code>Вывод test_test.sh</code></summary>

**** host1 ****

**** host1 **** ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:8a:fe:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 83065sec preferred_lft 83065sec
    inet6 fe80::5054:ff:fe8a:fee6/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:d5:4f:cb brd ff:ff:ff:ff:ff:ff
    inet6 fe80::c531:e9ac:c9c5:78e3/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:26:54:4d brd ff:ff:ff:ff:ff:ff
    inet6 fe80::7561:29f3:4dd5:11e8/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:8b:9a:cb brd ff:ff:ff:ff:ff:ff
    inet 10.1.0.1/24 brd 10.1.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe8b:9acb/64 scope link 
       valid_lft forever preferred_lft forever
10: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:d5:4f:cb brd ff:ff:ff:ff:ff:ff
    inet 192.168.12.1/30 brd 192.168.12.3 scope global noprefixroute vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fed5:4fcb/64 scope link 
       valid_lft forever preferred_lft forever
11: vlan13@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:26:54:4d brd ff:ff:ff:ff:ff:ff
    inet 192.168.13.1/30 brd 192.168.13.3 scope global noprefixroute vlan13
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe26:544d/64 scope link 
       valid_lft forever preferred_lft forever
**** host1 **** cat /etc/quagga/zebra.conf
hostname host1

log file /var/log/quagga/zebra.log

interface eth3
ip address 10.1.0.1/24

interface vlan12
ip address 192.168.12.1/30

interface vlan13
ip address 192.168.13.1/30
**** host1 **** cat /etc/quagga/zebra.conf
hostname host1

log file /var/log/quagga/zebra.log

interface eth3
ip address 10.1.0.1/24

interface vlan12
ip address 192.168.12.1/30

interface vlan13
ip address 192.168.13.1/30
**** host1 **** cat /etc/quagga/zebra.conf
hostname host1

log file /var/log/quagga/zebra.log

interface eth3
ip address 10.1.0.1/24

interface vlan12
ip address 192.168.12.1/30

interface vlan13
ip address 192.168.13.1/30
**** host1 **** tracepath 10.3.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.3.0.1                                              0.433ms reached
 1:  10.3.0.1                                              0.662ms reached
     Resume: pmtu 1500 hops 1 back 1 
**** host1 **** tracepath 10.1.0.1
 1:  10.1.0.1                                              0.057ms reached
     Resume: pmtu 65535 hops 1 back 1 

**** host2 ****

**** host2 **** ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:8a:fe:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 83186sec preferred_lft 83186sec
    inet6 fe80::5054:ff:fe8a:fee6/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:15:80:13 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::9f47:7619:22d:b8e5/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:91:8e:65 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::6fae:7d2:4535:f96a/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:87:c4:c5 brd ff:ff:ff:ff:ff:ff
    inet 10.2.0.1/24 brd 10.2.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe87:c4c5/64 scope link 
       valid_lft forever preferred_lft forever
10: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:15:80:13 brd ff:ff:ff:ff:ff:ff
    inet 192.168.12.2/30 brd 192.168.12.3 scope global noprefixroute vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe15:8013/64 scope link 
       valid_lft forever preferred_lft forever
11: vlan23@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:91:8e:65 brd ff:ff:ff:ff:ff:ff
    inet 192.168.23.1/30 brd 192.168.23.3 scope global vlan23
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe91:8e65/64 scope link 
       valid_lft forever preferred_lft forever
**** host2 **** cat /etc/quagga/zebra.conf
hostname host2

interface eth3
ip address 10.2.0.1/24

interface vlan12
ip address 192.168.12.2/30

interface vlan23
ip address 192.168.23.1/30

log file /var/log/quagga/zebra.log
**** host2 **** cat /etc/quagga/zebra.conf
hostname host2

interface eth3
ip address 10.2.0.1/24

interface vlan12
ip address 192.168.12.2/30

interface vlan23
ip address 192.168.23.1/30

log file /var/log/quagga/zebra.log
**** host2 **** cat /etc/quagga/zebra.conf
hostname host2

interface eth3
ip address 10.2.0.1/24

interface vlan12
ip address 192.168.12.2/30

interface vlan23
ip address 192.168.23.1/30

log file /var/log/quagga/zebra.log
**** host2 **** tracepath 10.3.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.3.0.1                                              0.413ms reached
 1:  10.3.0.1                                              0.685ms reached
     Resume: pmtu 1500 hops 1 back 1 
**** host2 **** tracepath 10.1.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.1.0.1                                              0.559ms reached
 1:  10.1.0.1                                              0.640ms reached
     Resume: pmtu 1500 hops 1 back 1 

**** host3 ****

**** host3 **** ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:8a:fe:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 83346sec preferred_lft 83346sec
    inet6 fe80::5054:ff:fe8a:fee6/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:dc:ce:37 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::436:245b:ff0c:34e5/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:47:66:48 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::c23e:7e7c:d81a:4b88/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:72:b1:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.3.0.1/24 brd 10.3.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe72:b1e6/64 scope link 
       valid_lft forever preferred_lft forever
10: vlan13@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:dc:ce:37 brd ff:ff:ff:ff:ff:ff
    inet 192.168.13.2/30 brd 192.168.13.3 scope global noprefixroute vlan13
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fedc:ce37/64 scope link 
       valid_lft forever preferred_lft forever
11: vlan23@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:47:66:48 brd ff:ff:ff:ff:ff:ff
    inet 192.168.23.2/30 brd 192.168.23.3 scope global noprefixroute vlan23
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe47:6648/64 scope link 
       valid_lft forever preferred_lft forever
**** host3 **** cat /etc/quagga/zebra.conf
hostname host3

interface eth3
ip address 10.3.0.1/24

interface vlan13
ip address 192.168.13.2/30

interface vlan23
ip address 192.168.23.2/30

log file /var/log/quagga/zebra.log
**** host3 **** cat /etc/quagga/zebra.conf
hostname host3

interface eth3
ip address 10.3.0.1/24

interface vlan13
ip address 192.168.13.2/30

interface vlan23
ip address 192.168.23.2/30

log file /var/log/quagga/zebra.log
**** host3 **** cat /etc/quagga/zebra.conf
hostname host3

interface eth3
ip address 10.3.0.1/24

interface vlan13
ip address 192.168.13.2/30

interface vlan23
ip address 192.168.23.2/30

log file /var/log/quagga/zebra.log
**** host3 **** tracepath 10.3.0.1
 1:  10.3.0.1                                              0.060ms reached
     Resume: pmtu 65535 hops 1 back 1 
**** host3 **** tracepath 10.1.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.1.0.1                                              0.641ms reached
 1:  10.1.0.1                                              0.553ms reached
     Resume: pmtu 1500 hops 1 back 1 
</details>

### Изобразить ассиметричный роутинг

```console
$ TASK=2 vagrant up
```

<details>
<summary><code>Вывод task_test.sh</code></summary>

**** host1 ****

# Host [127.0.0.1]:2204 found: line 14
/home/hightemp/.ssh/known_hosts updated.
Original contents retained as /home/hightemp/.ssh/known_hosts.old
**** host1 **** ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:8a:fe:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85444sec preferred_lft 85444sec
    inet6 fe80::5054:ff:fe8a:fee6/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:19:74:09 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::c21b:7d96:d74e:8037/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:98:16:0b brd ff:ff:ff:ff:ff:ff
    inet6 fe80::e1f7:2c6c:a4f5:4c32/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:a0:30:cc brd ff:ff:ff:ff:ff:ff
    inet 10.1.0.1/24 brd 10.1.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fea0:30cc/64 scope link 
       valid_lft forever preferred_lft forever
10: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:19:74:09 brd ff:ff:ff:ff:ff:ff
    inet 192.168.12.1/30 brd 192.168.12.3 scope global noprefixroute vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe19:7409/64 scope link 
       valid_lft forever preferred_lft forever
11: vlan13@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:98:16:0b brd ff:ff:ff:ff:ff:ff
    inet 192.168.13.1/30 brd 192.168.13.3 scope global noprefixroute vlan13
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe98:160b/64 scope link 
       valid_lft forever preferred_lft forever
**** host1 **** cat /etc/quagga/zebra.conf
hostname host1

log file /var/log/quagga/zebra.log

interface eth3
ip address 10.1.0.1/24

interface vlan12
ip address 192.168.12.1/30

interface vlan13
ip address 192.168.13.1/30
**** host1 **** cat /etc/quagga/zebra.conf
hostname host1

log file /var/log/quagga/zebra.log

interface eth3
ip address 10.1.0.1/24

interface vlan12
ip address 192.168.12.1/30

interface vlan13
ip address 192.168.13.1/30
**** host1 **** cat /etc/quagga/zebra.conf
hostname host1

log file /var/log/quagga/zebra.log

interface eth3
ip address 10.1.0.1/24

interface vlan12
ip address 192.168.12.1/30

interface vlan13
ip address 192.168.13.1/30
**** host1 **** tracepath 10.3.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.0.2.2                                              0.222ms 
 1:  10.0.2.2                                              0.412ms 
 2:  no reply
 3:  10.136.0.1                                            6.186ms asymm 63 
 4:  10.109.11.6                                          22.448ms asymm 62 
 5:  no reply
 6:  no reply
 7:  no reply
 8:  no reply
 9:  no reply
10:  no reply
11:  no reply
12:  no reply
13:  no reply
14:  no reply
15:  no reply
16:  no reply
17:  no reply
18:  no reply
19:  no reply
20:  no reply
21:  no reply
22:  no reply
23:  no reply
24:  no reply
25:  no reply
26:  no reply
27:  no reply
28:  no reply
29:  no reply
30:  no reply
     Too many hops: pmtu 1500
     Resume: pmtu 1500 
**** host1 **** tracepath 10.1.0.1
 1:  10.1.0.1                                              0.103ms reached
     Resume: pmtu 65535 hops 1 back 1 

**** host2 ****

# Host [127.0.0.1]:2205 found: line 14
/home/hightemp/.ssh/known_hosts updated.
Original contents retained as /home/hightemp/.ssh/known_hosts.old
**** host2 **** ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:8a:fe:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85486sec preferred_lft 85486sec
    inet6 fe80::5054:ff:fe8a:fee6/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:1a:ad:a4 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::447d:a424:10a:b0e8/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:cf:79:78 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::ea6a:6209:c90c:dbde/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:f4:39:5e brd ff:ff:ff:ff:ff:ff
    inet 10.2.0.1/24 brd 10.2.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fef4:395e/64 scope link 
       valid_lft forever preferred_lft forever
10: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:1a:ad:a4 brd ff:ff:ff:ff:ff:ff
    inet 192.168.12.2/30 brd 192.168.12.3 scope global noprefixroute vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe1a:ada4/64 scope link 
       valid_lft forever preferred_lft forever
11: vlan23@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:cf:79:78 brd ff:ff:ff:ff:ff:ff
    inet 192.168.23.1/30 brd 192.168.23.3 scope global noprefixroute vlan23
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fecf:7978/64 scope link 
       valid_lft forever preferred_lft forever
**** host2 **** cat /etc/quagga/zebra.conf
hostname host2

interface eth3
ip address 10.2.0.1/24

interface vlan12
ip address 192.168.12.2/30

interface vlan23
ip address 192.168.23.1/30

log file /var/log/quagga/zebra.log
**** host2 **** cat /etc/quagga/zebra.conf
hostname host2

interface eth3
ip address 10.2.0.1/24

interface vlan12
ip address 192.168.12.2/30

interface vlan23
ip address 192.168.23.1/30

log file /var/log/quagga/zebra.log
**** host2 **** cat /etc/quagga/zebra.conf
hostname host2

interface eth3
ip address 10.2.0.1/24

interface vlan12
ip address 192.168.12.2/30

interface vlan23
ip address 192.168.23.1/30

log file /var/log/quagga/zebra.log
**** host2 **** tracepath 10.3.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.3.0.1                                              0.438ms reached
 1:  10.3.0.1                                              0.457ms reached
     Resume: pmtu 1500 hops 1 back 1 
**** host2 **** tracepath 10.1.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.0.2.2                                              0.284ms 
 1:  10.0.2.2                                              0.420ms 
 2:  no reply
 3:  10.136.0.1                                           84.855ms asymm 63 
 4:  10.109.11.6                                          39.940ms asymm 62 
 5:  no reply
 6:  no reply
 7:  no reply
 8:  no reply
 9:  no reply
10:  no reply
11:  no reply
12:  no reply
13:  no reply
14:  no reply
15:  no reply
16:  no reply
17:  no reply
18:  no reply
19:  no reply
20:  no reply
21:  no reply
22:  no reply
23:  no reply
24:  no reply
25:  no reply
26:  no reply
27:  no reply
28:  no reply
29:  no reply
30:  no reply
     Too many hops: pmtu 1500
     Resume: pmtu 1500 

**** host3 ****

**** host3 **** ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:8a:fe:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85522sec preferred_lft 85522sec
    inet6 fe80::5054:ff:fe8a:fee6/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:de:d2:bd brd ff:ff:ff:ff:ff:ff
    inet6 fe80::4f03:ece7:c3b:45b3/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:cc:26:ab brd ff:ff:ff:ff:ff:ff
    inet6 fe80::de7d:8d14:8969:7084/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:7e:07:5b brd ff:ff:ff:ff:ff:ff
    inet 10.3.0.1/24 brd 10.3.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe7e:75b/64 scope link 
       valid_lft forever preferred_lft forever
10: vlan13@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:de:d2:bd brd ff:ff:ff:ff:ff:ff
    inet 192.168.13.2/30 brd 192.168.13.3 scope global noprefixroute vlan13
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fede:d2bd/64 scope link 
       valid_lft forever preferred_lft forever
11: vlan23@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:cc:26:ab brd ff:ff:ff:ff:ff:ff
    inet 192.168.23.2/30 brd 192.168.23.3 scope global noprefixroute vlan23
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fecc:26ab/64 scope link 
       valid_lft forever preferred_lft forever
**** host3 **** cat /etc/quagga/zebra.conf
hostname host3

interface eth3
ip address 10.3.0.1/24

interface vlan13
ip address 192.168.13.2/30

interface vlan23
ip address 192.168.23.2/30

log file /var/log/quagga/zebra.log
**** host3 **** cat /etc/quagga/zebra.conf
hostname host3

interface eth3
ip address 10.3.0.1/24

interface vlan13
ip address 192.168.13.2/30

interface vlan23
ip address 192.168.23.2/30

log file /var/log/quagga/zebra.log
**** host3 **** cat /etc/quagga/zebra.conf
hostname host3

interface eth3
ip address 10.3.0.1/24

interface vlan13
ip address 192.168.13.2/30

interface vlan23
ip address 192.168.23.2/30

log file /var/log/quagga/zebra.log
**** host3 **** tracepath 10.3.0.1
 1:  10.3.0.1                                              0.068ms reached
     Resume: pmtu 65535 hops 1 back 1 
**** host3 **** tracepath 10.1.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.0.2.2                                              0.306ms 
 1:  10.0.2.2                                              0.216ms 
 2:  no reply
 3:  10.136.0.1                                           16.260ms asymm 63 
 4:  10.109.11.6                                           9.867ms asymm 62 
 5:  no reply
 6:  no reply
 7:  no reply
 8:  no reply
 9:  no reply
10:  no reply
11:  no reply
12:  no reply
13:  no reply
14:  no reply
15:  no reply
16:  no reply
17:  no reply
18:  no reply
19:  no reply
20:  no reply
21:  no reply
22:  no reply
23:  no reply
24:  no reply
25:  no reply
26:  no reply
27:  no reply
28:  no reply
29:  no reply
30:  no reply
     Too many hops: pmtu 1500
     Resume: pmtu 1500 

</details>

### Сделать один из линков "дорогим", но что бы при этом роутинг был симметричным

```console
$ TASK=3 vagrant up
```

<details>
<summary><code>Вывод task_test.sh</code></summary>

**** host1 ****

# Host [127.0.0.1]:2204 found: line 14
/home/hightemp/.ssh/known_hosts updated.
Original contents retained as /home/hightemp/.ssh/known_hosts.old
**** host1 **** ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:8a:fe:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85867sec preferred_lft 85867sec
    inet6 fe80::5054:ff:fe8a:fee6/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:aa:19:b8 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::1722:21d7:169f:db36/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:7b:45:2f brd ff:ff:ff:ff:ff:ff
    inet6 fe80::b56e:668c:21fb:eae3/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:c7:48:00 brd ff:ff:ff:ff:ff:ff
    inet 10.1.0.1/24 brd 10.1.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fec7:4800/64 scope link 
       valid_lft forever preferred_lft forever
10: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:aa:19:b8 brd ff:ff:ff:ff:ff:ff
    inet 192.168.12.1/30 brd 192.168.12.3 scope global noprefixroute vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:feaa:19b8/64 scope link 
       valid_lft forever preferred_lft forever
11: vlan13@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:7b:45:2f brd ff:ff:ff:ff:ff:ff
    inet 192.168.13.1/30 brd 192.168.13.3 scope global noprefixroute vlan13
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe7b:452f/64 scope link 
       valid_lft forever preferred_lft forever
**** host1 **** cat /etc/quagga/zebra.conf
hostname host1

log file /var/log/quagga/zebra.log

interface eth3
ip address 10.1.0.1/24

interface vlan12
ip address 192.168.12.1/30

interface vlan13
ip address 192.168.13.1/30
**** host1 **** cat /etc/quagga/zebra.conf
hostname host1

log file /var/log/quagga/zebra.log

interface eth3
ip address 10.1.0.1/24

interface vlan12
ip address 192.168.12.1/30

interface vlan13
ip address 192.168.13.1/30
**** host1 **** cat /etc/quagga/zebra.conf
hostname host1

log file /var/log/quagga/zebra.log

interface eth3
ip address 10.1.0.1/24

interface vlan12
ip address 192.168.12.1/30

interface vlan13
ip address 192.168.13.1/30
**** host1 **** tracepath 10.3.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.0.2.2                                              0.193ms 
 1:  10.0.2.2                                              0.244ms 
 2:  no reply
 3:  10.136.0.1                                            8.879ms asymm 63 
 4:  10.109.11.6                                           5.550ms asymm 62 
 5:  no reply
 6:  no reply
 7:  no reply
 8:  no reply
 9:  no reply
10:  no reply
11:  no reply
12:  no reply
13:  no reply
14:  no reply
15:  no reply
16:  no reply
17:  no reply
18:  no reply
19:  no reply
20:  no reply
21:  no reply
22:  no reply
23:  no reply
24:  no reply
25:  no reply
26:  no reply
27:  no reply
28:  no reply
29:  no reply
30:  no reply
     Too many hops: pmtu 1500
     Resume: pmtu 1500 
**** host1 **** tracepath 10.1.0.1
 1:  10.1.0.1                                              0.089ms reached
     Resume: pmtu 65535 hops 1 back 1 

**** host2 ****

# Host [127.0.0.1]:2205 found: line 14
/home/hightemp/.ssh/known_hosts updated.
Original contents retained as /home/hightemp/.ssh/known_hosts.old
**** host2 **** ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:8a:fe:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85939sec preferred_lft 85939sec
    inet6 fe80::5054:ff:fe8a:fee6/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:c5:a4:c2 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::c53d:f1c8:dfb:6a8a/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:71:f9:ad brd ff:ff:ff:ff:ff:ff
    inet6 fe80::d832:cc73:5f54:4be2/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:80:ea:ee brd ff:ff:ff:ff:ff:ff
    inet 10.2.0.1/24 brd 10.2.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe80:eaee/64 scope link 
       valid_lft forever preferred_lft forever
10: vlan12@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:c5:a4:c2 brd ff:ff:ff:ff:ff:ff
    inet 192.168.12.2/30 brd 192.168.12.3 scope global noprefixroute vlan12
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fec5:a4c2/64 scope link 
       valid_lft forever preferred_lft forever
11: vlan23@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:71:f9:ad brd ff:ff:ff:ff:ff:ff
    inet 192.168.23.1/30 brd 192.168.23.3 scope global noprefixroute vlan23
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe71:f9ad/64 scope link 
       valid_lft forever preferred_lft forever
**** host2 **** cat /etc/quagga/zebra.conf
hostname host2

interface eth3
ip address 10.2.0.1/24

interface vlan12
ip address 192.168.12.2/30

interface vlan23
ip address 192.168.23.1/30

log file /var/log/quagga/zebra.log
**** host2 **** cat /etc/quagga/zebra.conf
hostname host2

interface eth3
ip address 10.2.0.1/24

interface vlan12
ip address 192.168.12.2/30

interface vlan23
ip address 192.168.23.1/30

log file /var/log/quagga/zebra.log
**** host2 **** cat /etc/quagga/zebra.conf
hostname host2

interface eth3
ip address 10.2.0.1/24

interface vlan12
ip address 192.168.12.2/30

interface vlan23
ip address 192.168.23.1/30

log file /var/log/quagga/zebra.log
**** host2 **** tracepath 10.3.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.3.0.1                                              0.435ms reached
 1:  10.3.0.1                                              0.387ms reached
     Resume: pmtu 1500 hops 1 back 1 
**** host2 **** tracepath 10.1.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.0.2.2                                              0.212ms 
 1:  10.0.2.2                                              0.133ms 
 2:  no reply
 3:  10.136.0.1                                            4.524ms asymm 63 
 4:  10.109.11.6                                           6.462ms asymm 62 
 5:  no reply
 6:  no reply
 7:  no reply
 8:  no reply
 9:  no reply
10:  no reply
11:  no reply
12:  no reply
13:  no reply
14:  no reply
15:  no reply
16:  no reply
17:  no reply
18:  no reply
19:  no reply
20:  no reply
21:  no reply
22:  no reply
23:  no reply
24:  no reply
25:  no reply
26:  no reply
27:  no reply
28:  no reply
29:  no reply
30:  no reply
     Too many hops: pmtu 1500
     Resume: pmtu 1500 

**** host3 ****

# Host [127.0.0.1]:2206 found: line 14
/home/hightemp/.ssh/known_hosts updated.
Original contents retained as /home/hightemp/.ssh/known_hosts.old
**** host3 **** ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:8a:fe:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85961sec preferred_lft 85961sec
    inet6 fe80::5054:ff:fe8a:fee6/64 scope link 
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:4b:f8:05 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::ec56:f2ee:e3a2:9554/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:52:c1:5d brd ff:ff:ff:ff:ff:ff
    inet6 fe80::f40f:9da0:873c:3bad/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
5: eth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:38:42:fe brd ff:ff:ff:ff:ff:ff
    inet 10.3.0.1/24 brd 10.3.0.255 scope global noprefixroute eth3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe38:42fe/64 scope link 
       valid_lft forever preferred_lft forever
10: vlan13@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:4b:f8:05 brd ff:ff:ff:ff:ff:ff
    inet 192.168.13.2/30 brd 192.168.13.3 scope global noprefixroute vlan13
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe4b:f805/64 scope link 
       valid_lft forever preferred_lft forever
11: vlan23@eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:52:c1:5d brd ff:ff:ff:ff:ff:ff
    inet 192.168.23.2/30 brd 192.168.23.3 scope global noprefixroute vlan23
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe52:c15d/64 scope link 
       valid_lft forever preferred_lft forever
**** host3 **** cat /etc/quagga/zebra.conf
hostname host3

interface eth3
ip address 10.3.0.1/24

interface vlan13
ip address 192.168.13.2/30

interface vlan23
ip address 192.168.23.2/30

log file /var/log/quagga/zebra.log
**** host3 **** cat /etc/quagga/zebra.conf
hostname host3

interface eth3
ip address 10.3.0.1/24

interface vlan13
ip address 192.168.13.2/30

interface vlan23
ip address 192.168.23.2/30

log file /var/log/quagga/zebra.log
**** host3 **** cat /etc/quagga/zebra.conf
hostname host3

interface eth3
ip address 10.3.0.1/24

interface vlan13
ip address 192.168.13.2/30

interface vlan23
ip address 192.168.23.2/30

log file /var/log/quagga/zebra.log
**** host3 **** tracepath 10.3.0.1
 1:  10.3.0.1                                              0.082ms reached
     Resume: pmtu 65535 hops 1 back 1 
**** host3 **** tracepath 10.1.0.1
 1?: [LOCALHOST]                                         pmtu 1500
 1:  10.0.2.2                                              0.266ms 
 1:  10.0.2.2                                              0.175ms 
 2:  no reply
 3:  10.136.0.1                                            4.776ms asymm 63 
 4:  10.109.11.6                                           5.221ms asymm 62 
 5:  no reply
 6:  no reply
 7:  no reply
 8:  no reply
 9:  no reply
10:  no reply
11:  no reply
12:  no reply
13:  no reply
14:  no reply
15:  no reply
16:  no reply
17:  no reply
18:  no reply
19:  no reply
20:  no reply
21:  no reply
22:  no reply
23:  no reply
24:  no reply
25:  no reply
26:  no reply
27:  no reply
28:  no reply
29:  no reply
30:  no reply
     Too many hops: pmtu 1500
     Resume: pmtu 1500 

</details>
