# Instalação Zabbix-server usando ansible

![Badge](https://img.shields.io/badge/ansible-zabbix-red)

## Dependências
![Badge](https://img.shields.io/badge/ansible-2.9.10-blue)

## Suporte SO

- Ubuntu20
- Debian10
- Rocky8
- Almalinux8
- Centos8

## Versões suportadas zabbix

- 4.4
- 5.0
- 5.2
- 5.4
- 6.0

Suporte a banco de dados MYSQL e Postgresql com timescaledb

# Como Usar!!!

## Crie o arquivo de inventário hosts 

## Variáveis
| Nome | Descrição | Default | 
|------|-----------|---------|
| zabbix_version | Versão zabbix-server | 4.4|
| zabbix_server_database_long | Tipo de database[mysql/pgsql] |  mysql
| zabbix_server_database | Tipo de database[mysql/pgsql] | mysql
| zbx_database_address | IP database | 127.0.0.1
| zbx_front_address | IP front | 127.0.0.1
| zbx_server_address | IP zabbix | 127.0.0.1
| zbx_server_ha | IP zabbix node 2 (Somente para versão 6.0) | 127.0.0.1
| zabbix_server_ha | habilita o HA (Somente para a Versão 6.0) enable|disable | disable

## Exemplo de playbook para instalação em localhost Mysql (DEFAULT)
```
- name: Install Banco mysql
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
  - zabbix-front
```
## Exemplo de playbook para instalação em localhost postgresql
```
- name: Install Banco postgresql
  hosts: db
  become: yes
  roles:
  - postgresql

- name: Install Zabbix Server
  hosts: zbx
  vars:
    zabbix_server_database_long: pgsql
    zabbix_server_database: pgsql
  become: yes
  roles:
  - zabbix-server

- name: Install Front
  hosts: web
  vars:
    zabbix_server_database: pgsql
  become: yes
  roles:
  - zabbix-front
```  
## Exemplo de playbook para instalação em servidores separados Mysql
```
---
- name: Install Banco mysql
  hosts: db
  vars:
    zbx_server_address: IP-SERVER-ZABBIX
    zbx_front_address: IP-FRONT
    zbx_server_ip_ha: IP-SERVER-NODE-2 ##(Caso for usar HA somente versão 6.0)
  become: yes
  roles:
  - mysql

- name: Install Zabbix Server
  hosts: zbx
  vars:
    zbx_database_address: IP-SERVER-DATABASE
    zabbix_server_ha: enable ##(Caso for usar HA somente versão 6.0)
  become: yes
  roles:
  - zabbix-server

- name: Install Front
  hosts: web
  vars:    
    zabbix_server_ha: enable ##(Caso for usar HA somente versão 6.0)
    zbx_database_address: IP-SERVER-DATABASE
    zbx_server_address: IP-SERVER-ZABBIX
  become: yes
  roles:
  - zabbix-front
```
## Exemplo de playbook para instalação em servidores separados postgresql
```
---
- name: Install Banco postgresql
  hosts: db
  vars:
    zbx_server_address: IP-SERVER-ZABBIX
    zbx_front_address: IP-SERVER-FRONT
    zbx_server_ip_ha: IP-SERVER-NODE-2 ##(Caso for usar HA somente versão 6.0)
  become: true
  roles:
  - postgresql

- name: Install Zabbix Server
  hosts: zabbix
  vars:
    zabbix_server_ha: enable ##(Caso for usar HA somente versão 6.0)
    zbx_database_address: IP-SERVER-DATABASE
    zabbix_server_database_long: pgsql
    zabbix_server_database: pgsql
  become: true
  roles:
  - zabbix-server

- name: Install Front
  hosts: web
  vars:
    zabbix_server_ha: enable ##(Caso for usar HA somente versão 6.0)
    zbx_server_address: IP-SERVER-ZABBIX
    zbx_database_address: IP-SERVER-DATABASE
    zabbix_server_database: pgsql
  become: true
  roles:
  - zabbix-front
```
## Exemplo arquivo de inventório HA versão 6.0
```
[db]
IP-DATABASE
[zabbix]
IP-ZABBIX_SERVER
IP-ZABBIX_SERVER-NODE2
[web]
IP_FRONT
```

## Execute o playbook
``` 
ansible-playbook -i hosts zabbix.yml --extra-vars "zabbix_version=5.0"
```
## Licença
![Badge](https://img.shields.io/badge/license-GPLv3-green)
