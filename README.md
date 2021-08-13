# Instalação zabbix-server 5.4 usando ansible

![Badge](https://img.shields.io/badge/ansible-zabbix-red)
![Badge](https://img.shields.io/badge/zabbix-5.4-red)

## Dependências
![Badge](https://img.shields.io/badge/ansible-2.9.10-blue)
![Badge](https://img.shields.io/badge/Rocky-8-blue)

# Como Usar

## Crie o arquivo de inventário hosts 

Exemplo para instalação em servidores separados, caso utilize chaves .pem
```
[mysql]
IP_DESTINO ansible_ssh_private_key_file=/PATH/DESTINO/key.pem ansible_user=vagrant
[zabbix]
IP_DESTINO ansible_ssh_private_key_file=/PATH/DESTINO/key.pem ansible_user=vagrant
[front]
IP_DESTINO ansible_ssh_private_key_file=/PATH/DESTINO/key.pem ansible_user=vagrant
```
Exemplo de instalação localhost
```
[zabbix-server]
IP_DESTINO ansible_ssh_private_key_file=/PATH/DESTINO/key.pem ansible_user=vagrant

[zabbix-server]
127.0.0.1
```
## Exemplo de playbook
```
---
- name: Install Banco
  hosts: mysql
  vars:
    mysql_password_root: default123
  become: yes
  roles:
  - mysql

- name: Install Zabbix Server
  hosts: zabbix
  vars:
    zbx_server_address: localhost
    zbx_database_address: localhost
    zbx_database_password: default123
    mysql_password_root: default123
    zbx_database_user_root: root
  become: yes
  roles:
  - zabbix-server

- name: Install Front
  hosts: front
  vars:
    zbx_database_address: localhost
    zbx_server_address: localhost
    zbx_database_port: 3306
    zbx_database_password: default123
    pass_zabbix: zabbix2021
  become: yes
  roles:
  - zbx-front
```
``` 
ansible-playbook -i hosts zabbix.yml

Caso utilize acesso local use o comando
ansible-playbook -i hosts zabbix.yml --ask-pass

``` 
## Licença
![Badge](https://img.shields.io/badge/license-GPLv3-green)
