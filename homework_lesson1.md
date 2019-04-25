### Установка образа через vagrant
```bash
~/Projects/otus-linux$ env -u GEM_HOME -u GEM_PATH vagrant up
```

![](images/Screenshot_20190425_221508.png)

### Запуск образа
```bash
~/Projects/otus-linux$ env -u GEM_HOME -u GEM_PATH vagrant ssh otuslinux
```

### Скачивание образа с помощью curl с kernel.org

![](images/Screenshot_20190425_225314.png)

### Установка пакетов необходимых для сборки ядра

```bash
sudo yum install ncurses-devel make gcc bc openssl-devel
```

![](images/Screenshot_20190425_225854.png)


