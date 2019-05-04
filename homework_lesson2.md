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

###

