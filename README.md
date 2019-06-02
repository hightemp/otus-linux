
## Домашнее задание к уроку 8

```console
$ sudo su -
```

<details><summary>Подготовка</summary>

### Устанавливаю CentOS 7 с LVM на новую вм

![](/images/lesson8/Screenshot_20190602_213531.png)

### Включаю GUI в Vagrantfile

```ruby
vb.gui = true
```

</details>

## Попасть в систему без пароля несколькими способами

### Способ 1

#### Запускаю вм с помощью GUI VirtualBox

#### Дожидаюсь загрузки GRUB
#### Вибираю пункт и нажимаю e

![](/images/lesson8/Screenshot_20190602_233644.png)

#### Добавляю в строку с linux16 `rw init=/bin/bash`
#### Нажимаю CTRL+X

![](/images/lesson8/Screenshot_20190602_234010.png)

#### Проверяю

```console
$ mount -o remount,rw /
$ mount | grep root
```

![](/images/lesson8/Screenshot_20190602_234154.png)

### Меняю пароль

```console
$ mount -o remount,rw /sysroot
$ chroot /sysroot
$ passwd root
$ touch /.autorelabel
```

### Способ 2

#### Запускаю вм с помощью GUI VirtualBox

#### Дожидаюсь загрузки GRUB
#### Вибираю пункт и нажимаю e

![](/images/lesson8/Screenshot_20190602_233644.png)

#### Добавляю в строку с linux16 `rd.break`
#### Нажимаю CTRL+X

![](/images/lesson8/Screenshot_20190602_234534.png)

### Меняю пароль

```console
$ mount -o remount,rw /sysroot
$ chroot /sysroot
$ passwd root
$ touch /.autorelabel
```

![](/images/lesson8/Screenshot_20190602_234741.png)

### Способ 3

#### Запускаю вм с помощью GUI VirtualBox

#### Дожидаюсь загрузки GRUB
#### Вибираю пункт и нажимаю e

![](/images/lesson8/Screenshot_20190602_233644.png)

#### Добавляю в строку с linux16 `rw init=/sysroot/bin/sh`
#### Нажимаю CTRL+X

![](/images/lesson8/Screenshot_20190602_235109.png)

### Меняю пароль

```console
$ mount -o remount,rw /sysroot
$ chroot /sysroot
$ passwd root
$ touch /.autorelabel
```

## Установить систему с LVM, после чего переименовать VG

### Проверяю lvm

```console
$ vgs
```

![](/images/lesson8/Screenshot_20190602_221130.png)

### Переименовываю VolGroup00 в OtusRoot

```console
$ vgrename centos OtusRoot
```

### Заменяю в файлах /etc/fstab, /etc/default/grub, /boot/grub2/grub.cfg.

```console
$ for f in "/etc/fstab" "/etc/default/grub" "/boot/grub2/grub.cfg"; do sed -i 's/centos\([-/]\)/OtusRoot\1/g' "$f"; done
```

![](/images/lesson8/Screenshot_20190602_225353.png)
![](/images/lesson8/Screenshot_20190602_225600.png)

### Пересоздаю initrd образ

```console
$ mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
```

![](/images/lesson8/Screenshot_20190602_230233.png)

### Перезагружаюсь

```console
$ reboot
```

![](/images/lesson8/Screenshot_20190602_232637.png)

## Добавить модуль в initrd

### Создаю директорию

```console
$ mkdir /usr/lib/dracut/modules.d/01test
```

### Создаю файлы

```console
$ cat > /usr/lib/dracut/modules.d/01test/test.sh <<- EOF
#!/bin/bash

exec 0<>/dev/console 1<>/dev/console 2<>/dev/console
cat <<'msgend'
Hello! You are in dracut module!
 ___________________
< I'm dracut module >
 -------------------
   \
    \
        .--.
       |o_o |
       |:_/ |
      //   \ \
     (|     | )
    /'\_   _/\`\
    \___)=(___/
msgend
sleep 10
echo " continuing...."
EOF
```

```console
$ cat > /usr/lib/dracut/modules.d/01test/module-setup.sh <<- EOF
#!/bin/bash

check() {
    return 0
}

depends() {
    return 0
}

install() {
    inst_hook cleanup 00 "\${moddir}/test.sh"
}
EOF
```

### Пересобираю образ

```console
$ mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
```

### Проверяю

```console
$ lsinitrd -m /boot/initramfs-$(uname -r).img | grep test
```

![](/images/lesson8/Screenshot_20190603_003906.png)

### Перезагружаюсь
### Дожидаюсь загрузки GRUB
### Вибираю пункт и нажимаю e
### Убираю rghb и quiet

![](/images/lesson8/Screenshot_20190603_004211.png)
