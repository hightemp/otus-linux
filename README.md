
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

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-9.P2.el7 <<>> web1.dns.lab
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 35640
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;web1.dns.lab.			IN	A

;; ANSWER SECTION:
web1.dns.lab.		3600	IN	A	10.0.10.3

;; AUTHORITY SECTION:
dns.lab.		3600	IN	NS	ns01.dns.lab.
dns.lab.		3600	IN	NS	ns02.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.		3600	IN	A	10.0.10.1
ns02.dns.lab.		3600	IN	A	10.0.10.2

;; Query time: 2 msec
;; SERVER: 10.0.10.1#53(10.0.10.1)
;; WHEN: Fri Oct 25 04:04:02 UTC 2019
;; MSG SIZE  rcvd: 127


$ dig web2.dns.lab

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-9.P2.el7 <<>> web2.dns.lab
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 26086
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;web2.dns.lab.			IN	A

;; AUTHORITY SECTION:
dns.lab.		600	IN	SOA	ns01.dns.lab. root.dns.lab. 3101201902 3600 600 86400 600

;; Query time: 0 msec
;; SERVER: 10.0.10.1#53(10.0.10.1)
;; WHEN: Fri Oct 25 04:04:41 UTC 2019
;; MSG SIZE  rcvd: 87


$ dig www.newdns.lab

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-9.P2.el7 <<>> www.newdns.lab
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 19911
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 2, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.newdns.lab.			IN	A

;; ANSWER SECTION:
www.newdns.lab.		3600	IN	A	10.0.10.4
www.newdns.lab.		3600	IN	A	10.0.10.3

;; AUTHORITY SECTION:
newdns.lab.		3600	IN	NS	ns01.dns.lab.
newdns.lab.		3600	IN	NS	ns02.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.		3600	IN	A	10.0.10.1
ns02.dns.lab.		3600	IN	A	10.0.10.2

;; Query time: 0 msec
;; SERVER: 10.0.10.1#53(10.0.10.1)
;; WHEN: Fri Oct 25 04:05:00 UTC 2019
;; MSG SIZE  rcvd: 149


$ dig -x 10.0.10.4
; <<>> DiG 9.11.4-P2-RedHat-9.11.4-9.P2.el7 <<>> -x 10.0.10.4
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 2104
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;4.10.0.10.in-addr.arpa.		IN	PTR

;; AUTHORITY SECTION:
10.IN-ADDR.ARPA.	86400	IN	SOA	10.IN-ADDR.ARPA. . 0 28800 7200 604800 86400

;; Query time: 0 msec
;; SERVER: 10.0.10.1#53(10.0.10.1)
;; WHEN: Fri Oct 25 04:05:20 UTC 2019
;; MSG SIZE  rcvd: 101


$ dig @10.0.10.2 web1.dns.lab

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-9.P2.el7 <<>> @10.0.10.2 web1.dns.lab
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 28190
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 2, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;web1.dns.lab.			IN	A

;; ANSWER SECTION:
web1.dns.lab.		3600	IN	A	10.0.10.3

;; AUTHORITY SECTION:
dns.lab.		3600	IN	NS	ns01.dns.lab.
dns.lab.		3600	IN	NS	ns02.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.		3600	IN	A	10.0.10.1
ns02.dns.lab.		3600	IN	A	10.0.10.2

;; Query time: 1 msec
;; SERVER: 10.0.10.2#53(10.0.10.2)
;; WHEN: Fri Oct 25 04:05:46 UTC 2019
;; MSG SIZE  rcvd: 127


$ dig @10.0.10.2 web2.dns.lab

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-9.P2.el7 <<>> @10.0.10.2 web2.dns.lab
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 42014
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;web2.dns.lab.			IN	A

;; AUTHORITY SECTION:
dns.lab.		600	IN	SOA	ns01.dns.lab. root.dns.lab. 3101201902 3600 600 86400 600

;; Query time: 1 msec
;; SERVER: 10.0.10.2#53(10.0.10.2)
;; WHEN: Fri Oct 25 04:06:48 UTC 2019
;; MSG SIZE  rcvd: 87


$ dig @10.0.10.2 www.newdns.lab

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-9.P2.el7 <<>> @10.0.10.2 www.newdns.lab
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 3962
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 2, ADDITIONAL: 3

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.newdns.lab.			IN	A

;; ANSWER SECTION:
www.newdns.lab.		3600	IN	A	10.0.10.4
www.newdns.lab.		3600	IN	A	10.0.10.3

;; AUTHORITY SECTION:
newdns.lab.		3600	IN	NS	ns02.dns.lab.
newdns.lab.		3600	IN	NS	ns01.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.		3600	IN	A	10.0.10.1
ns02.dns.lab.		3600	IN	A	10.0.10.2

;; Query time: 0 msec
;; SERVER: 10.0.10.2#53(10.0.10.2)
;; WHEN: Fri Oct 25 04:07:09 UTC 2019
;; MSG SIZE  rcvd: 149


$ dig @10.0.10.2 -x 10.0.10.4

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-9.P2.el7 <<>> @10.0.10.2 -x 10.0.10.4
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NXDOMAIN, id: 13865
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;4.10.0.10.in-addr.arpa.		IN	PTR

;; AUTHORITY SECTION:
10.IN-ADDR.ARPA.	86400	IN	SOA	10.IN-ADDR.ARPA. . 0 28800 7200 604800 86400

;; Query time: 0 msec
;; SERVER: 10.0.10.2#53(10.0.10.2)
;; WHEN: Fri Oct 25 04:07:27 UTC 2019
;; MSG SIZE  rcvd: 101


```