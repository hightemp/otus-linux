## Домашнее задание к уроку 2

### Добавить в Vagrantfile еще дисков

#### Открываю файл Vagrantfile

```bash
vim Vagrantfile
```

#### Добавляю строку

```
:sata5 => {
        :dfile => './sata5.vdi',
        :size => 250, # Megabytes
        :port => 5
}
```

#### Сохраняю

###  Запускаю Vagrant

```bash
vagrant up
vargrant ssh
```

### Проверяю наличие диска

```bash
sudo lshw -short | grep disk
```

![](images/lesson2/Screenshot_20190504_134136.png)

### Проверяю не смотированы ли диски

```bash
sudo mount | grep "/dev/sd[bcdef]"
# И отмонитрую, если таковые иеются: sudo umount 
```

### Проверяю таблицу разделов

```bash
sudo parted -l
```

![](images/lesson2/Screenshot_20190504_143435.png)

### Зануляю суперблоки

```bash
sudo mdadm --zero-superblock --force /dev/sd{b,c,d,e,f}
```

![](images/lesson2/Screenshot_20190504_135510.png)

### Создаем на дисках разделы

```bash
sudo parted -s -a optimal /dev/sdb mklabel gpt -- mkpart primary ext4 0% 100%
sudo parted -s -a optimal /dev/sdc mklabel gpt -- mkpart primary ext4 0% 100%
sudo parted -s -a optimal /dev/sdd mklabel gpt -- mkpart primary ext4 0% 100%
sudo parted -s -a optimal /dev/sde mklabel gpt -- mkpart primary ext4 0% 100%
sudo parted -s -a optimal /dev/sdf mklabel gpt -- mkpart primary ext4 0% 100%
```

### Проверяю

```bash
sudo parted -l
```

![](images/lesson2/Screenshot_20190504_152343.png)

### Создаю RAID 10 из 5 партиций

```bash
sudo mdadm --create --verbose /dev/md0 -l 10 -n 5 /dev/sd{b,c,d,e,f}1
```

### Проверяю RAID

```bash
sudo mdadm --detail /dev/md0
```

![](images/lesson2/Screenshot_20190504_153044.png)

### Создаю файловую систему ext4

```bash
sudo mkfs.ext4 /dev/md0
```

### Создаю точку монтирования и проверяю монтируется ли фс

```bash
sudo mkdir /raid
sudo mount /dev/md0 /raid/
# создаю тестовые файлы
sudo touch /raid/file{0..10}.txt
```

### Создаю конфигурационный файл mdadm.conf

```bash
sudo mkdir /etc/mdadm
sudo sh -c 'echo "DEVICE partitions" > /etc/mdadm/mdadm.conf'
sudo sh -c "mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf"
```

![](images/lesson2/Screenshot_20190504_193719.png)

### Добавляю запись в /etc/fstab

```bash
sudo vi /etc/fstab
```

Добавляю следующее

```bash
/dev/md0 /raid ext4 defaults 1 2
```

### Ломаю диск /dev/sdb1

```bash
sudo mdadm /dev/md0 --fail /dev/sdb1
```

### Проверяю

```bash
cat /proc/mdstat
```

![](images/lesson2/Screenshot_20190504_195426.png)

### Чиню

```bash
sudo mdadm /dev/md0 --remove /dev/sdb1
sudo mdadm /dev/md0 --add /dev/sdb1
```

### Проверяю

```bash
cat /proc/mdstat
```

![](images/lesson2/Screenshot_20190504_195831.png)

### Размонтирую RAID

```bash
sudo umount /dev/md0
```

### Удаляю таблицу разделов и фс

```bash
sudo dd if=/dev/zero of=/dev/md0 bs=512 count=1
```

### Создаю GPT и 5 партиций

```bash
sudo parted -s /dev/md0 mklabel gpt
sudo parted /dev/md0 mkpart primary ext4 0% 20%
sudo parted /dev/md0 mkpart primary ext4 20% 40%
sudo parted /dev/md0 mkpart primary ext4 40% 60%
sudo parted /dev/md0 mkpart primary ext4 60% 80%
sudo parted /dev/md0 mkpart primary ext4 80% 100%
for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done
sudo mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do sudo mount /dev/md0p$i /raid/part$i; done
```

### Изменяю /etc/fstab

```bash
sudo vi /etc/fstab
```

Заменяю `/dev/md0 /raid ext4 defaults 1 2` на

```bash
/dev/md0p1 /raid/part1 ext4 defaults 1 2
/dev/md0p2 /raid/part2 ext4 defaults 1 2
/dev/md0p3 /raid/part3 ext4 defaults 1 2
/dev/md0p4 /raid/part4 ext4 defaults 1 2
/dev/md0p5 /raid/part5 ext4 defaults 1 2
```

## Итоговый скрипт для Vagrant

```bash
mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
yum install -y mdadm smartmontools hdparm gdisk
sudo parted -s -a optimal /dev/sdb mklabel gpt -- mkpart primary ext4 0% 100%
sudo parted -s -a optimal /dev/sdc mklabel gpt -- mkpart primary ext4 0% 100%
sudo parted -s -a optimal /dev/sdd mklabel gpt -- mkpart primary ext4 0% 100%
sudo parted -s -a optimal /dev/sde mklabel gpt -- mkpart primary ext4 0% 100%
sudo parted -s -a optimal /dev/sdf mklabel gpt -- mkpart primary ext4 0% 100%
sudo mdadm --create --verbose /dev/md0 -l 10 -n 5 /dev/sd{b,c,d,e,f}1
sudo mkdir /etc/mdadm
sudo sh -c 'echo "DEVICE partitions" > /etc/mdadm/mdadm.conf'
sudo sh -c "mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf"
sudo parted -s /dev/md0 mklabel gpt
sudo parted /dev/md0 mkpart primary ext4 0% 20%
sudo parted /dev/md0 mkpart primary ext4 20% 40%
sudo parted /dev/md0 mkpart primary ext4 40% 60%
sudo parted /dev/md0 mkpart primary ext4 60% 80%
sudo parted /dev/md0 mkpart primary ext4 80% 100%
for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done
sudo mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do sudo mount /dev/md0p$i /raid/part$i; done
sudo sh -c 'echo "/dev/md0p1 /raid/part1 ext4 defaults 1 2" >> /etc/fstab'
sudo sh -c 'echo "/dev/md0p2 /raid/part2 ext4 defaults 1 2" >> /etc/fstab'
sudo sh -c 'echo "/dev/md0p3 /raid/part3 ext4 defaults 1 2" >> /etc/fstab'
sudo sh -c 'echo "/dev/md0p4 /raid/part4 ext4 defaults 1 2" >> /etc/fstab'
sudo sh -c 'echo "/dev/md0p5 /raid/part5 ext4 defaults 1 2" >> /etc/fstab'
```
