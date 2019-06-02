
## Домашнее задание к уроку 8

```console
$ sudo su -
```

<details><summary>Подготовка</summary>

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

![](/images/lesson8/Screenshot_20190602_202302.png)

### 

## Добавить модуль в initrd
