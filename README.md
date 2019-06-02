
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

![](/images/lesson8/Screenshot_20190602_173908.png)

#### Нажимаю e

#### Добавляю в строку с linux16 `rw init=/bin/bash`

![]()

### Способ 2

#### Запускаю вм с помощью GUI VirtualBox

![](/images/lesson8/Screenshot_20190602_173908.png)

#### Нажимаю e

#### Добавляю в строку с linux16 `rd.break`

![]()

### Способ 3

#### Запускаю вм с помощью GUI VirtualBox

![](/images/lesson8/Screenshot_20190602_173908.png)

#### Нажимаю e

#### Добавляю в строку с linux16 `rw init=/sysroot/bin/sh`

![]()


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
$ for f in "/etc/fstab" "/etc/default/grub" "/boot/grub2/grub.cfg"; do sed -i 's/centos([-\/])/OtusRoot$1/g' "$f"; done
```

![](/images/lesson8/Screenshot_20190602_225353.png)
![](/images/lesson8/Screenshot_20190602_222610.png)

### Пересоздаю initrd образ

```console
$ mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
```

![](/images/lesson8/Screenshot_20190602_223237.png)

### Перезагружаюсь

```console
$ reboot
```


## Добавить модуль в initrd
