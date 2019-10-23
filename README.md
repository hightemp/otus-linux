
## Домашнее задание к уроку 13

```
LDAP
1. Установить FreeIPA
2. Написать playbook для конфигурации клиента
3*. Настроить авторизацию по ssh-ключам

В git - результирующий playbook
```

### Запуск

```console
$ vagrant up
```

### Создание пользователя

```console
$ vagrant ssh server -c 'export PYTHONIOENCODING=utf8; echo password | kinit admin && ipa user-add --first="Test" --last="Testov" --cn="Test Testov" --password test --shell="/bin/bash"'
```

### Проверка

```console
$ vagrant ssh client
$ su -l test
```

![](/images/%D0%A1%D0%BD%D0%B8%D0%BC%D0%BE%D0%BA%20%D1%8D%D0%BA%D1%80%D0%B0%D0%BD%D0%B0%20%D0%BE%D1%82%202019-10-23%2023-53-04.png)