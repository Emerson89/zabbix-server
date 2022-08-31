# Instalação Zabbix-server usando ansible

![Badge](https://img.shields.io/badge/ansible-zabbix-red)

## Dependências
![Badge](https://img.shields.io/badge/ansible-2.9.10-blue)

## Suporte SO

- Ubuntu20
- Debian11
- Rocky8
- Almalinux8
- Centos8

## Versões suportadas zabbix

- 4.4 - Menos Debian 11
- 5.0
- 5.2
- 5.4
- 6.0

Suporte a banco de dados MYSQL e Postgresql com timescaledb

show variables like '%expire_logs%';
SET GLOBAL binlog_expire_logs_seconds = (60*60*24*10);

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
---
- hosts: all
  become: true
  roles:
    - {role: roles/mysql}
    - {role: roles/zabbix-server}
    - {role: roles/zabbix-front}

```
## Exemplo de playbook para instalação em localhost postgresql
```
---
- hosts: all
  become: true
  roles:
    - {role: roles/postgresql}
    - {role: roles/zabbix-server}
    - {role: roles/zabbix-front}

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

## Para nível de aprendizado e teste há opção de utilizar o vagrant com virtualbox

## Para instalação: 
- https://www.vagrantup.com/downloads
- https://www.virtualbox.org/wiki/Downloads

No arquivo Vagranfile se encontra opções de SO que é suportado nesta instalação o default é rocky 8, caso queira utilizar outra opção descomente a linha

```
vms = {
'rocky-srv' => {'memory' => '2024', 'cpus' => '1', 'ip' => '12', 'box' => 'rockylinux/8'},
#'debian-srv' => {'memory' => '1024', 'cpus' => '1', 'ip' => '13', 'box' => 'debian/buster64'},
#'ubuntu-srv' => {'memory' => '1024', 'cpus' => '2', 'ip' => '14', 'box' => 'ubuntu/focal64'},
}
```
Para setar versão zabbix em *zabbix.yml* altere a variável *zabbix_version* default *4.4* conforme sua necessidade

# Para utilizar
```
vagrant up - Provisiona a VM
vagrant ssh - Acesso via ssh
vagrant halt - Desliga a VM
```
Terminado o provisionamento basta acessar no navegador http://192.168.33.12 - (default) para acesso ao Zabbix

## Licença
![Badge](https://img.shields.io/badge/license-GPLv3-green)
