# Instalação zabbix-server 5.4 usando ansible

![Badge](https://img.shields.io/badge/ansible-zabbix-red)
![Badge](https://img.shields.io/badge/zabbix-5.4-red)

## Dependências
![Badge](https://img.shields.io/badge/ansible-2.9.10-blue)
![Badge](https://img.shields.io/badge/Rocky-8.4-blue)

# Como Usar!!!

## Crie o arquivo de inventário hosts 

Exemplo para instalação em servidores separados, siga nesta ordem o padrão é localhost
```
[db]
IP_DESTINO ansible_ssh_private_key_file=/PATH/DESTINO/key.pem ansible_user=vagrant
[zbx]
IP_DESTINO ansible_ssh_private_key_file=/PATH/DESTINO/key.pem ansible_user=vagrant
[web]
IP_DESTINO ansible_ssh_private_key_file=/PATH/DESTINO/key.pem ansible_user=vagrant
```
Exemplo de instalação localhost
```
[db]
127.0.0.1
[zbx]
127.0.0.1
[web]
127.0.0.1
```
## Exemplo de playbook para instalação em localhost padrão
```
- name: Install Banco
  hosts: db
  become: yes
  roles:
  - mysql

- name: Install Zabbix Server
  hosts: zbx
  become: yes
  roles:
  - zabbix-server

- name: Install Front
  hosts: web
  become: yes
  roles:
  - zbx-front
```
## Inside variáveis DB localhost zabbix-server/vars/main.yml:
```
mysql_databases:
  - name: "{{ zbx_database_db }}"
    encoding: utf8
    collation: utf8_bin
mysql_users:
  - name: "{{ zbx_database_user }}"
    password: "{{ zbx_database_password }}"
    priv: "{{ zbx_database_db }}.*:ALL"
```
## Exemplo de playbook para instalação em servidores separados
```
---
- name: Install Banco
  hosts: db
  vars:
    zbx_user_privileges: '%'
  become: yes
  roles:
  - mysql

- name: Install Zabbix Server
  hosts: zbx
  vars:
    zbx_server_address: IP-SERVER-ZABBIX
    zbx_database_address: IP-SERVER-DATABASE
    zbx_user_privileges: '%'
  become: yes
  roles:
  - zabbix-server

- name: Install Front
  hosts: web
  vars:
    zbx_database_address: IP-SERVER-DATABASE
    zbx_server_address: IP-SERVER-ZABBIX
    zbx_database_port: 3306
  become: yes
  roles:
  - zbx-front
```
## Inside variáveis DB em servidores separados mysql/vars/main.yml:
```
 mysql_root_users:
  - login_user: root
    login_password: " " 
    name: "{{ mysql_root_username }}"
    password: "{{ mysql_root_password }}"
    host: "{{ zbx_user_privileges }}"
    priv: "*.*:ALL,GRANT"
```
## Inside variáveis DB em servidores separados zabbix-server/vars/main.yml:
```
mysql_databases:
  - name: "{{ zbx_database_db }}"
    login_host: "{{ zbx_database_address }}"
    login_user: "{{ mysql_root_username }}"
    login_password: "{{ mysql_root_password }}"
    host: "{{ zbx_user_privileges }}"
    encoding: utf8
    collation: utf8_bin
mysql_users:
  - login_host: "{{ zbx_database_address }}"
    login_user: "{{ mysql_root_username }}"
    login_password: "{{ mysql_root_password }}"
    host: "{{ zbx_user_privileges }}"
    name: "{{ zbx_database_user }}"
    password: "{{ zbx_database_password }}"
    priv: "{{ zbx_database_db }}.*:ALL"
```
## Postgresql vars
postgresql_databases:
  - name: "{{ zbx_database_name }}"
    login_host: "{{ zbx_database_address }}"
    login_user: "{{ postgresql_user }}"
    login_password: ""
postgresql_users:
  - login_host: "{{ zbx_database_address }}"
    login_user: "{{ postgresql_user }}"
    login_password: ""
    name: "{{ zbx_database_user }}"
    password: "{{ db_zabbix_pass.stdout }}"
    
``` 
ansible-playbook -i hosts zabbix.yml

``` 
## Licença
![Badge](https://img.shields.io/badge/license-GPLv3-green)
