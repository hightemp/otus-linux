
## Домашнее задание к уроку 11

> PAM
> 1. Запретить всем пользователям, кроме группы admin логин в выходные и праздничные дни


### Создаю трех пользователей

```console
$ sudo useradd day && \
sudo useradd night && \
sudo useradd friday
```

### Устанавливаю пароли

```console
$ echo "Otus2019" | sudo passwd --stdin day && \
echo "Otus2019" | sudo passwd --stdin night && \
echo "Otus2019" | sudo passwd --stdin friday
```

### Добавляю возможность заходить по SSH по паролю

```console
$ sudo bash -c "sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service"
```

### Добавляю настройки для модуля pam_time

```console
$ cat | sudo tee -a /etc/security/time.conf <<-EOF
*;*;day;Al0800-2000
*;*;night;!Al0800-2000
*;*;friday;Fr
EOF
```

### Включаю модуль pam_time

```console
$ sudo sed -i '/account    required     pam_nologin.so/a account required pam_time.so' /etc/pam.d/sshd
```

### Проверяю

![](/images/lesson11/Screenshot_20190618_001815.png)

### Добавим права пользователю day

### Подключаю модуль pam_cap

```console
$ sudo sed -i '/auth       include      postlogin/a auth required pam_cap.so' /etc/pam.d/sshd
```

### Создаю файл с правами /etc/security/capability.conf

```console
$ sudo cat > /etc/security/capability.conf <<-EOF
cap_net_bind_service day
EOF
```

### Выдаю разрешение программе netcat

```console
$ sudo setcap cap_net_bind_service=ei /usr/bin/ncat
```

### Проверяю

```console
$ 
```
