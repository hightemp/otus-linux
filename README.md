
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

### Редактирую /etc/default/grub

```
GRUB_TIMEOUT=30
```

### Обновляю grub

```
grub2-mkconfig -o /boot/grub2/grub.cfg
```

</details>

## Попасть в систему без пароля несколькими способами

### Способ 1

#### Запускаю вм с помощью GUI VirtualBox

#### Дожидаюсь загрузки GRUB
#### Вибираю пункт и нажимаю e

![](/images/lesson8/Screenshot_20190602_233644.png)

#### Добавляю в строку с linux16 `rw init=/bin/bash`

![](/images/lesson8/Screenshot_20190602_234010.png)

#### Проверяю

```console
$ mount -o remount,rw /
$ mount | grep root
```

### Меняю пароль

```console
$ mount -o remount,rw /sysroot
$ chroot /sysroot
$ passwd root
$ touch /.autorelabel
```

![](/images/lesson8/Screenshot_20190602_234154.png)

### Способ 2

#### Запускаю вм с помощью GUI VirtualBox

#### Дожидаюсь загрузки GRUB
#### Вибираю пункт и нажимаю e

![](/images/lesson8/Screenshot_20190602_233644.png)

#### Добавляю в строку с linux16 `rd.break`

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
