### Установка образа через vagrant
```bash
~/Projects/otus-linux$ env -u GEM_HOME -u GEM_PATH vagrant up
```

![](images/Screenshot_20190425_221508.png)

### Запуск образа
```bash
~/Projects/otus-linux$ env -u GEM_HOME -u GEM_PATH vagrant ssh otuslinux
```

### Скачивание образа с помощью curl с kernel.org. Качаю stable 5.0.9.

```bash
curl https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.0.9.tar.xz -O
```

![](images/Screenshot_20190425_225314.png)

### Установка пакетов, необходимых для сборки ядра

```bash
sudo yum install ncurses-devel make gcc bc openssl-devel
sudo yum install elfutils-libelf-devel
sudo yum install rpm-build
```

![](images/Screenshot_20190425_225854.png)

### Распаковка архива с исходниками ядра

```bash
tar xvf linux-5.0.9.tar.xz
```

### Перехожу в папку linux-5.0.9. Копирую /boot/config-3.10.0-957.5.1.el7.x86_64

```bash
cd linux-5.0.9/
sudo cp -v /boot/config-3.10.0-957.5.1.el7.x86_64 .config
```

![](images/Screenshot_20190425_233123.png)

### Запускаю make menuconfig

```bash
make menuconfig
```

![](images/Screenshot_20190425_234204.png)

Получаю ошибку

```bash
/bin/sh: flex: command not found
make[2]: *** [scripts/kconfig/zconf.lex.c] Error 127
make[1]: *** [menuconfig] Error 2
make: *** [sub-make] Error 2
```

### Установка недостающих пакетов

```bash
sudo yum install flex
sudo yum install bison
```

### Запускаю make menuconfig

![](images/Screenshot_20190425_235024.png)

### Нажимаю Save

![](images/Screenshot_20190425_235155.png)

### Нажимаю OK

![](images/Screenshot_20190425_235330.png)

### Выхожу

### Запускаю процесс компиляции

```bash
make rpm-pkg -j3
```


