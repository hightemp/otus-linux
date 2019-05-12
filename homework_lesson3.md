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



