
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
*stat dir
bacula-dir Version: 5.2.13 (19 February 2013) x86_64-redhat-linux-gnu redhat (Core)
Daemon started 24-Oct-19 14:35. Jobs: run=12, running=0 mode=0,0
 Heap: heap=135,168 smbytes=106,680 max_bytes=113,230 bufs=250 max_bufs=289

Scheduled Jobs:
Level          Type     Pri  Scheduled          Name               Volume
===================================================================================
Incremental    Backup    10  24-Oct-19 15:21    Backup configs incremental server 1 vol-0001
Incremental    Backup    10  24-Oct-19 15:21    Backup configs incremental server 2 vol-0001
Incremental    Backup    10  24-Oct-19 15:31    Backup configs incremental server 1 vol-0001
Incremental    Backup    10  24-Oct-19 15:31    Backup configs incremental server 2 vol-0001
Differential   Backup    10  24-Oct-19 15:35    Backup configs differential server 1 vol-0001
Differential   Backup    10  24-Oct-19 15:35    Backup configs differential server 2 vol-0001
Incremental    Backup    10  24-Oct-19 15:41    Backup configs incremental server 1 vol-0001
Incremental    Backup    10  24-Oct-19 15:41    Backup configs incremental server 2 vol-0001
Incremental    Backup    10  24-Oct-19 15:51    Backup configs incremental server 1 vol-0001
Incremental    Backup    10  24-Oct-19 15:51    Backup configs incremental server 2 vol-0001
Incremental    Backup    10  24-Oct-19 16:01    Backup configs incremental server 1 vol-0001
Incremental    Backup    10  24-Oct-19 16:01    Backup configs incremental server 2 vol-0001
Differential   Backup    10  24-Oct-19 16:05    Backup configs differential server 1 vol-0001
Differential   Backup    10  24-Oct-19 16:05    Backup configs differential server 2 vol-0001
Incremental    Backup    10  24-Oct-19 16:11    Backup configs incremental server 1 vol-0001
Incremental    Backup    10  24-Oct-19 16:11    Backup configs incremental server 2 vol-0001
Full           Backup    10  25-Oct-19 02:00    Backup configs full server 1 vol-0001
Full           Backup    10  25-Oct-19 02:00    Backup configs full server 2 vol-0001
====

Running Jobs:
Console connected at 24-Oct-19 15:16
No Jobs running.
====

Terminated Jobs:
 JobId  Level    Files      Bytes   Status   Finished        Name 
====================================================================
     3  Full          0         0   Error    24-Oct-19 14:44 Backup_configs_incremental_server_1
     4  Full          0         0   Error    24-Oct-19 14:47 Backup_configs_incremental_server_2
     5  Full      2,411    31.41 M  OK       24-Oct-19 14:51 Backup_configs_incremental_server_1
     6  Full          0         0   Error    24-Oct-19 14:54 Backup_configs_incremental_server_2
     7  Incr          0         0   OK       24-Oct-19 15:01 Backup_configs_incremental_server_1
     8  Full      2,411    31.41 M  OK       24-Oct-19 15:01 Backup_configs_incremental_server_2
     9  Full      2,411    31.41 M  OK       24-Oct-19 15:05 Backup_configs_differential_server_1
    10  Full      2,411    31.41 M  OK       24-Oct-19 15:05 Backup_configs_differential_server_2
    11  Incr          0         0   OK       24-Oct-19 15:11 Backup_configs_incremental_server_1
    12  Incr          0         0   OK       24-Oct-19 15:11 Backup_configs_incremental_server_2

====
You have messages.
*show schedule
Schedule: name=Incremental Every 10 Minutes
  --> Run Level=Incremental
      hour=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 
      mday=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 
      month=0 1 2 3 4 5 6 7 8 9 10 11 
      wday=0 1 2 3 4 5 6 
      wom=0 1 2 3 4 
      woy=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 
      mins=1
  --> Run Level=Incremental
      hour=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 
      mday=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 
      month=0 1 2 3 4 5 6 7 8 9 10 11 
      wday=0 1 2 3 4 5 6 
      wom=0 1 2 3 4 
      woy=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 
      mins=11
  --> Run Level=Incremental
      hour=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 
      mday=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 
      month=0 1 2 3 4 5 6 7 8 9 10 11 
      wday=0 1 2 3 4 5 6 
      wom=0 1 2 3 4 
      woy=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 
      mins=21
  --> Run Level=Incremental
      hour=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 
      mday=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 
      month=0 1 2 3 4 5 6 7 8 9 10 11 
      wday=0 1 2 3 4 5 6 
      wom=0 1 2 3 4 
      woy=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 
      mins=31
  --> Run Level=Incremental
      hour=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 
      mday=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 
      month=0 1 2 3 4 5 6 7 8 9 10 11 
      wday=0 1 2 3 4 5 6 
      wom=0 1 2 3 4 
      woy=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 
      mins=41
  --> Run Level=Incremental
      hour=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 
      mday=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 
      month=0 1 2 3 4 5 6 7 8 9 10 11 
      wday=0 1 2 3 4 5 6 
      wom=0 1 2 3 4 
      woy=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 
      mins=51
Schedule: name=Differential Every 30 Munites
  --> Run Level=Differential
      hour=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 
      mday=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 
      month=0 1 2 3 4 5 6 7 8 9 10 11 
      wday=0 1 2 3 4 5 6 
      wom=0 1 2 3 4 
      woy=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 
      mins=5
  --> Run Level=Differential
      hour=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 
      mday=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 
      month=0 1 2 3 4 5 6 7 8 9 10 11 
      wday=0 1 2 3 4 5 6 
      wom=0 1 2 3 4 
      woy=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 
      mins=35
Schedule: name=Daily Full
  --> Run Level=Full
      hour=2 
      mday=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 
      month=0 1 2 3 4 5 6 7 8 9 10 11 
      wday=0 1 2 3 4 5 6 
      wom=0 1 2 3 4 
      woy=0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 
      mins=0
*
```

![](/images/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202019-10-24%2018-17-19.png)