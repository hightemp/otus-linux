
## Домашнее задание к уроку 16

    Домашнее задание
    Настраиваем бэкапы
    Настроить стенд Vagrant с двумя виртуальными машинами server и client.

    Настроить политику бэкапа директории /etc с клиента:
    1) Полный бэкап - раз в день
    2) Инкрементальный - каждые 10 минут
    3) Дифференциальный - каждые 30 минут

    Запустить систему на два часа. Для сдачи ДЗ приложить list jobs, list files jobid=<id>
    и сами конфиги bacula-*

```console
$ vagrant up
```

### Проверка

```console
$ vagrant ssh backup-server
$ sudo bconsole
Connecting to Director localhost:9101
1000 OK: bacula-dir Version: 5.2.13 (19 February 2013)
Enter a period to cancel a command.
*list jobs
Automatically selected Catalog: MyCatalog
Using Catalog "MyCatalog"
+-------+--------------------------------------+---------------------+------+-------+----------+------------+-----------+
| jobid | name                                 | starttime           | type | level | jobfiles | jobbytes   | jobstatus |
+-------+--------------------------------------+---------------------+------+-------+----------+------------+-----------+
|     1 | Backup configs differential server 1 | 2019-10-24 14:35:10 | B    | F     |        0 |          0 | E         |
|     2 | Backup configs differential server 2 | 2019-10-24 14:38:12 | B    | F     |        0 |          0 | E         |
|     3 | Backup configs incremental server 1  | 2019-10-24 14:41:14 | B    | F     |        0 |          0 | E         |
|     4 | Backup configs incremental server 2  | 2019-10-24 14:44:16 | B    | F     |        0 |          0 | E         |
|     5 | Backup configs incremental server 1  | 2019-10-24 14:51:02 | B    | F     |    2,411 | 31,414,886 | T         |
|     6 | Backup configs incremental server 2  | 2019-10-24 14:51:05 | B    | F     |        0 |          0 | E         |
|     7 | Backup configs incremental server 1  | 2019-10-24 15:01:02 | B    | I     |        0 |          0 | T         |
|     8 | Backup configs incremental server 2  | 2019-10-24 15:01:05 | B    | F     |    2,411 | 31,414,886 | T         |
|     9 | Backup configs differential server 1 | 2019-10-24 15:05:02 | B    | F     |    2,411 | 31,414,886 | T         |
|    10 | Backup configs differential server 2 | 2019-10-24 15:05:05 | B    | F     |    2,411 | 31,414,886 | T         |
|    11 | Backup configs incremental server 1  | 2019-10-24 15:11:02 | B    | I     |        0 |          0 | T         |
|    12 | Backup configs incremental server 2  | 2019-10-24 15:11:05 | B    | I     |        0 |          0 | T         |
|    13 | Backup configs incremental server 1  | 2019-10-24 15:21:03 | B    | I     |        0 |          0 | T         |
|    14 | Backup configs incremental server 2  | 2019-10-24 15:21:05 | B    | I     |        0 |          0 | T         |
|    15 | Backup configs incremental server 1  | 2019-10-24 15:31:03 | B    | I     |        0 |          0 | T         |
|    16 | Backup configs incremental server 2  | 2019-10-24 15:31:05 | B    | I     |        0 |          0 | T         |
|    17 | Backup configs differential server 1 | 2019-10-24 15:35:03 | B    | D     |        0 |          0 | T         |
|    18 | Backup configs differential server 2 | 2019-10-24 15:35:05 | B    | D     |        0 |          0 | T         |
|    19 | Backup configs incremental server 1  | 2019-10-24 15:41:03 | B    | I     |        0 |          0 | T         |
|    20 | Backup configs incremental server 2  | 2019-10-24 15:41:05 | B    | I     |        0 |          0 | T         |
|    21 | Backup configs incremental server 1  | 2019-10-24 15:51:03 | B    | I     |        0 |          0 | T         |
|    22 | Backup configs incremental server 2  | 2019-10-24 15:51:05 | B    | I     |        0 |          0 | T         |
|    23 | Backup configs incremental server 1  | 2019-10-24 16:01:03 | B    | I     |        0 |          0 | T         |
|    24 | Backup configs incremental server 2  | 2019-10-24 16:01:05 | B    | I     |        0 |          0 | T         |
|    25 | Backup configs differential server 1 | 2019-10-24 16:05:03 | B    | D     |        0 |          0 | T         |
|    26 | Backup configs differential server 2 | 2019-10-24 16:05:05 | B    | D     |        0 |          0 | T         |
|    27 | Backup configs incremental server 1  | 2019-10-24 16:11:03 | B    | I     |        0 |          0 | T         |
|    28 | Backup configs incremental server 2  | 2019-10-24 16:11:05 | B    | I     |        0 |          0 | T         |
|    29 | Backup configs incremental server 1  | 2019-10-24 16:21:03 | B    | I     |        0 |          0 | T         |
|    30 | Backup configs incremental server 2  | 2019-10-24 16:21:05 | B    | I     |        0 |          0 | T         |
|    31 | Backup configs incremental server 1  | 2019-10-24 16:31:02 | B    | I     |        0 |          0 | T         |
|    32 | Backup configs incremental server 2  | 2019-10-24 16:31:04 | B    | I     |        0 |          0 | T         |
|    33 | Backup configs differential server 1 | 2019-10-24 16:35:02 | B    | D     |        0 |          0 | T         |
|    34 | Backup configs differential server 2 | 2019-10-24 16:35:04 | B    | D     |        0 |          0 | T         |
|    35 | Backup configs incremental server 1  | 2019-10-24 16:41:02 | B    | I     |        0 |          0 | T         |
|    36 | Backup configs incremental server 2  | 2019-10-24 16:41:04 | B    | I     |        0 |          0 | T         |
|    37 | Backup configs incremental server 1  | 2019-10-24 16:51:02 | B    | I     |        0 |          0 | T         |
|    38 | Backup configs incremental server 2  | 2019-10-24 16:51:04 | B    | I     |        0 |          0 | T         |
|    39 | Backup configs incremental server 1  | 2019-10-24 17:01:02 | B    | I     |        0 |          0 | T         |
|    40 | Backup configs incremental server 2  | 2019-10-24 17:01:04 | B    | I     |        0 |          0 | T         |
|    41 | Backup configs differential server 1 | 2019-10-24 17:05:02 | B    | D     |        0 |          0 | T         |
|    42 | Backup configs differential server 2 | 2019-10-24 17:05:04 | B    | D     |        0 |          0 | T         |
|    43 | Backup configs incremental server 1  | 2019-10-24 17:11:02 | B    | I     |        0 |          0 | T         |
|    44 | Backup configs incremental server 2  | 2019-10-24 17:11:04 | B    | I     |        0 |          0 | T         |
|    45 | Backup configs incremental server 1  | 2019-10-24 17:21:02 | B    | I     |        0 |          0 | T         |
|    46 | Backup configs incremental server 2  | 2019-10-24 17:21:04 | B    | I     |        0 |          0 | T         |
|    47 | Backup configs incremental server 1  | 2019-10-24 17:31:02 | B    | I     |        0 |          0 | T         |
|    48 | Backup configs incremental server 2  | 2019-10-24 17:31:04 | B    | I     |        0 |          0 | T         |
|    49 | Backup configs differential server 1 | 2019-10-24 17:35:02 | B    | D     |        0 |          0 | T         |
|    50 | Backup configs differential server 2 | 2019-10-24 17:35:04 | B    | D     |        0 |          0 | T         |
|    51 | Backup configs incremental server 1  | 2019-10-24 17:41:02 | B    | I     |        0 |          0 | T         |
|    52 | Backup configs incremental server 2  | 2019-10-24 17:41:04 | B    | I     |        0 |          0 | T         |
|    53 | Backup configs incremental server 1  | 2019-10-24 17:51:02 | B    | I     |        0 |          0 | T         |
|    54 | Backup configs incremental server 2  | 2019-10-24 17:51:04 | B    | I     |        0 |          0 | T         |
|    55 | Backup configs incremental server 1  | 2019-10-24 18:01:02 | B    | I     |        0 |          0 | T         |
|    56 | Backup configs incremental server 2  | 2019-10-24 18:01:04 | B    | I     |        0 |          0 | T         |
|    57 | Backup configs differential server 1 | 2019-10-24 18:05:02 | B    | D     |        0 |          0 | T         |
|    58 | Backup configs differential server 2 | 2019-10-24 18:05:04 | B    | D     |        0 |          0 | T         |
|    59 | Backup configs incremental server 1  | 2019-10-24 18:11:02 | B    | I     |        0 |          0 | T         |
|    60 | Backup configs incremental server 2  | 2019-10-24 18:11:05 | B    | I     |        0 |          0 | T         |
|    61 | Backup configs incremental server 1  | 2019-10-24 18:21:02 | B    | I     |        0 |          0 | T         |
|    62 | Backup configs incremental server 2  | 2019-10-24 18:21:05 | B    | I     |        0 |          0 | T         |
+-------+--------------------------------------+---------------------+------+-------+----------+------------+-----------+
You have messages.
*list files jobid=1
+-------+--------------------------------------+---------------------+------+-------+----------+----------+-----------+
| jobid | name                                 | starttime           | type | level | jobfiles | jobbytes | jobstatus |
+-------+--------------------------------------+---------------------+------+-------+----------+----------+-----------+
|     1 | Backup configs differential server 1 | 2019-10-24 14:35:10 | B    | F     |        0 |        0 | E         |
+-------+--------------------------------------+---------------------+------+-------+----------+----------+-----------+
*list files jobid=62
+-------+-------------------------------------+---------------------+------+-------+----------+----------+-----------+
| jobid | name                                | starttime           | type | level | jobfiles | jobbytes | jobstatus |
+-------+-------------------------------------+---------------------+------+-------+----------+----------+-----------+
|    62 | Backup configs incremental server 2 | 2019-10-24 18:21:05 | B    | I     |        0 |        0 | T         |
+-------+-------------------------------------+---------------------+------+-------+----------+----------+-----------+
*
```

![](/images/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202019-10-24%2018-17-19.png)