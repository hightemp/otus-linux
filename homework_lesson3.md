##  Домашнее задание к уроку 3 "Файловые системы и LVM"

### Запускаю vagrant

```bash
vagrant up
vargrant ssh
```

### Ставлю пакет xfsdump

```bash
sudo yum install xfsdump
```

### Подготавливаю временный том

```bash
sudo pvcreate /dev/sdb
sudo vgcreate vg_root /dev/sdb
sudo lvcreate -n lv_root -l +100%FREE /dev/vg_root
sudo mkfs.xfs /dev/vg_root/lv_root
sudo mount /dev/vg_root/lv_root /mnt
```

### Копирую данные

```bash
sudo xfsdump -J - /dev/VolGroup00/LogVol00 | sudo xfsrestore -J - /mnt
```

![](/images/lesson3/Screenshot_20190512_135515.png)

### Сымитируем root

```bash
for i in /proc/ /sys/ /dev/ /run/ /boot/; do sudo mount --bind $i /mnt/$i; done
sudo chroot /mnt/
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

### Обновляю образ initrd

```bash
cd /boot ; for i in `ls initramfs-*img`; do sudo dracut -v $i `echo $i|sed "s/initramfs-//g;
s/.img//g"` --force; done
```

![](/images/lesson3/Screenshot_20190512_140232.png)

### Заменяю в /boot/grub2/grub.cfg `rd.lvm.lv=VolGroup00/LogVol00` на `rd.lvm.lv=vg_root/lv_root`

```bash
sudo sed -i -- 's/VolGroup00\/LogVol00/vg_root\/lv_root/g' /boot/grub2/grub.cfg
```

### Перезагружаюсь

```bash
exit
sudo reboot
```

### Проверяю

```bash
lsblk
```

![](/images/lesson3/Screenshot_20190512_141659.png)

### Удаляю старый раздел

```bash
sudo lvremove /dev/VolGroup00/LogVol00
```

### Создаю новый раздел на 8G

```bash
sudo lvcreate -n VolGroup00/LogVol00 -L 8G /dev/VolGroup00
```

### Создаю фс и монтирую

```bash
sudo mkfs.xfs /dev/VolGroup00/LogVol00
sudo mount /dev/VolGroup00/LogVol00 /mnt
```

### Копирую все обратно

```bash
sudo xfsdump -J - /dev/vg_root/lv_root | sudo xfsrestore -J - /mnt
```

![](/images/lesson3/Screenshot_20190512_144013.png)


### Переконфигурируем GRUB

```bash
for i in /proc/ /sys/ /dev/ /run/ /boot/; do sudo mount --bind $i /mnt/$i; done
sudo chroot /mnt/
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

### Обновляю образы

```bash
cd /boot ; for i in `ls initramfs-*img`; do sudo dracut -v $i `echo $i|sed "s/initramfs-//g;
s/.img//g"` --force; done
```

![](/images/lesson3/Screenshot_20190512_145445.png)

### Выделяю том под /var

```bash
sudo pvcreate /dev/sdc /dev/sdd
sudo vgcreate vg_var /dev/sdc /dev/sdd
sudo lvcreate -L 950M -m1 -n lv_var vg_var
```

![](/images/lesson3/Screenshot_20190512_145946.png)

### Создаю ФС и перемещаю туда /var

```bash
sudo mkfs.ext4 /dev/vg_var/lv_var
sudo mount /dev/vg_var/lv_var /mnt
sudo cp -aR /var/* /mnt/
```

### Сохраняю содержимое /var

```bash
sudo mkdir /tmp/oldvar && mv /var/* /tmp/oldvar
```

### Монтирую /var

```bash
sudo umount /mnt 
sudo mount /dev/vg_var/lv_var /var
```

### Добавляю запись в /etc/fstab

```bash
sudo sh -c "echo \"`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0\" >> /etc/fstab"
```

![](/images/lesson3/Screenshot_20190512_150907.png)

### Перезагружаюсь

```bash
exit
sudo reboot
```

### Удаляю `lv_root`

```bash
sudo lvremove /dev/vg_root/lv_root
sudo vgremove /dev/vg_root
sudo pvremove /dev/sdb
```

### Создаю том для /home

```bash
sudo lvcreate -n LogVol_Home -L 2G /dev/VolGroup00
sudo mkfs.xfs /dev/VolGroup00/LogVol_Home
sudo mount /dev/VolGroup00/LogVol_Home /mnt/
sudo cp -aR /home/* /mnt/ 
sudo rm -rf /home/*
sudo umount /mnt
sudo mount /dev/VolGroup00/LogVol_Home /home/
```

### Добавляю запись в `/etc/fstab`

```bash
cd /
sudo sh -c "echo \"`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0\" >> /etc/fstab"
```

![](/images/lesson3/Screenshot_20190512_152951.png)



