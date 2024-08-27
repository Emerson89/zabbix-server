# Instalação Zabbix-server usando ansible

![Badge](https://img.shields.io/badge/ansible-zabbix-red)

## Dependências

- ansible 2.16.6

- python3.10


## Install dependencias

```bash
pip install -r requirements.txt 
```

## Suporte SO

- Ubuntu20
- Ubuntu22
- Debian11
- Debian12
- Rocky8
- Almalinux8
- Centos8

## Versões OS suportadas Zabbix

| Versões Zabbix |  Debian 11 | Debian 12 | Ubuntu 20 | Ubuntu 22 | Rocky 8 | Almalinux 8 | Centos 8 |
|   ----         |     ---    |    ---    |    ---    |    ---    |   ---   |     ---     |    ---   |
|    4.4         |      No    |     Yes   |     Yes   |      No   |   Yes   |       Yes   |    Yes   |
|    5.0         |      Yes   |     Yes   |     Yes   |      No   |   Yes   |       Yes   |    Yes   |
|    5.2         |      Yes   |     Yes   |     Yes   |      No   |   Yes   |       Yes   |    Yes   |
|    5.4         |      Yes   |     Yes   |     Yes   |      No   |   Yes   |       Yes   |    Yes   |
|    6.0         |      Yes   |     Yes   |     Yes   |      Yes  |   Yes   |       Yes   |    Yes   |
|    6.4         |      Yes   |     Yes   |     Yes   |      Yes  |   Yes   |       Yes   |    Yes   |
|    7.0         |      No    |     Yes   |     No    |      Yes  |   Yes   |       Yes   |    Yes   |

Suporte a banco de dados MySQL e Postgresql com timescaledb

Para limitar uso de espaço em disco pelo arquivo de log binlog do mysql que por default é 30 dias para expurgo você pode reduzir no banco com comando abaixo:
```
show variables like '%expire_logs%';
SET GLOBAL binlog_expire_logs_seconds = (60*60*24*10);
```

# Como Usar!!!

## Crie o arquivo de inventário hosts 

## Variáveis

| Nome | Descrição | Default | 
|------|-----------|---------|
| zabbix_version | versão zabbix-server | 4.4|
| zabbix_server_database_long | Tipo de database[mysql/pgsql] |  mysql
| zabbix_server_database | Tipo de database[mysql/pgsql] | mysql
| zbx_database_address | IP database | 127.0.0.1
| zbx_front_address | IP zabbix-front | 127.0.0.1
| zbx_server_address | IP zabbix-server | 127.0.0.1
| zbx_server_ip_ha | IP zabbix node 2 **(Somente para versão 6.0 ou acima)** | 127.0.0.1
| zabbix_server_ha | habilita o HA **(Somente para a Versão 6.0 ou acima)** true|false | false
| mysql_root_pass | password user root **mysql** | Tg0z64OVddNzFwNA==
| db_zabbix_pass | password user zabbix **mysql** | Tg0z64OVddNzFwNA==
| postgresql_version | versão postgresql | 13
| zabbix_database_partition | habilita particionamento **mysql** | false
| history_days | history em dias para realizar o particionamento **mysql** | 13
| trends_month | thends em mes para realizar o particionamento **mysql** | 2

## Exemplo basico de playbook para instalação em localhost MySQL (DEFAULT)
```yaml
---
- hosts: all
  become: true
  vars:
    zabbix_version: 7.0
  roles:
    - {role: roles/mysql}
    - {role: roles/zabbix-server}
    - {role: roles/zabbix-front}
```
## Exemplo de playbook para instalação em localhost particionamento do banco de dados MySQL
```yaml
---
- hosts: all
  become: true
  vars:
    zabbix_database_partition: true
    history_days: 10
    trends_month: 1
    zabbix_version: 7.0
  roles:
    - {role: roles/mysql}
    - {role: roles/zabbix-server}
    - {role: roles/zabbix-front}
```
## Exemplo de playbook para instalação em localhost postgresql
```yaml
---
- hosts: all
  become: true
  vars:
    zabbix_server_database: pgsql
    zabbix_server_database_long: pgsql
    zabbix_version: 7.0
  roles:
    - {role: roles/postgresql}
    - {role: roles/zabbix-server}
    - {role: roles/zabbix-front}

```
## Exemplo de playbook para instalação em localhost postgresql usando outra versão postgresql
```yaml
---
- hosts: all
  become: true
  vars:
    zabbix_server_database: pgsql
    zabbix_server_database_long: pgsql
    postgresql_version: 14
    zabbix_version: 7.0
  roles:
    - {role: roles/postgresql}
    - {role: roles/zabbix-server}
    - {role: roles/zabbix-front}

```
## Exemplo de playbook para instalação em servidores separados Mysql
```yaml
---
- name: Install Banco mysql
  hosts: db
  vars:
    zbx_server_address: IP-SERVER-ZABBIX
    zbx_front_address: IP-FRONT
    zbx_server_ip_ha: IP-SERVER-NODE-2 ##(Caso for usar HA somente versão 6.0 acima)
  become: yes
  roles:
  - mysql

- name: Install Zabbix Server
  hosts: zbx
  vars:
    zbx_database_address: IP-SERVER-DATABASE
    zabbix_server_ha: true ##(Caso for usar HA somente versão 6.0 acima)
    zabbix_version: 7.0
  become: yes
  roles:
  - zabbix-server

- name: Install Front
  hosts: web
  vars:    
    zabbix_server_ha: true ##(Caso for usar HA somente versão 6.0 acima)
    zbx_database_address: IP-SERVER-DATABASE
    zbx_server_address: IP-SERVER-ZABBIX
    zabbix_version: 7.0
  become: yes
  roles:
  - zabbix-front
```
## Exemplo de playbook para instalação em servidores separados postgresql
```yaml
---
- name: Install Banco postgresql
  hosts: db
  vars:
    zbx_server_address: IP-SERVER-ZABBIX
    zbx_front_address: IP-SERVER-FRONT
    zbx_server_ip_ha: IP-SERVER-NODE-2 ##(Caso for usar HA somente versão 6.0 acima)
  become: true
  roles:
  - postgresql

- name: Install Zabbix Server
  hosts: zabbix
  vars:
    zabbix_server_ha: true ##(Caso for usar HA somente versão 6.0 acima)
    zbx_database_address: IP-SERVER-DATABASE
    zabbix_server_database_long: pgsql
    zabbix_server_database: pgsql
    zabbix_version: 7.0
  become: true
  roles:
  - zabbix-server

- name: Install Front
  hosts: web
  vars:
    zabbix_server_ha: true ##(Caso for usar HA somente versão 6.0 acima)
    zbx_server_address: IP-SERVER-ZABBIX
    zbx_database_address: IP-SERVER-DATABASE
    zabbix_server_database: pgsql
    zabbix_version: 7.0
  become: true
  roles:
  - zabbix-front
```

## Usando group_vars

Ex.

```bash
group_vars/
├── db
---
zbx_server_address: 172.16.33.11
zbx_front_address: 172.16.33.12
├── front
---
zbx_database_address: 172.16.33.10
zbx_server_address: 172.16.33.11
zabbix_version: 7.0
zabbix_server_database: pgsql
└── server
---
zbx_database_address: 172.16.33.10
zabbix_version: 7.0
zabbix_server_database_long: pgsql
zabbix_server_database: pgsql
```

```yaml
---
- hosts: db
  become: true
  roles:
    - {role: ../roles/postgresql}

- hosts: server
  become: true
  roles:
    - {role: ../roles/zabbix-server}

- hosts: front
  become: true
  roles:
    - {role: ../roles/zabbix-front}    
```    
#
## Exemplo arquivo de inventório HA versão 6.0 acima

```yaml
[db]
IP-DATABASE ansible_ssh_private_key_file=PATH/private_key ansible_user=vagrant
[zabbix]
IP-ZABBIX_SERVER ansible_ssh_private_key_file=PATH/private_key ansible_user=vagrant
IP-ZABBIX_SERVER-NODE2 ansible_ssh_private_key_file=PATH/private_key ansible_user=vagrant
[web]
IP_FRONT ansible_ssh_private_key_file=PATH/private_key ansible_user=vagrant
```
#
## Execute o playbook

```bash
ansible-playbook -i hosts zabbix.yml
```

#
## Para nível de aprendizado e teste há opção de utilizar o vagrant com virtualbox

## Para instalação: 

- https://www.vagrantup.com/downloads
- https://www.virtualbox.org/wiki/Downloads


[OPTIONAL] - *configured for the host-only network is not within the allowed ranges*

```bash
The IP address configured for the host-only network is not within the
allowed ranges. Please update the address used to be within the allowed
ranges and run the command again.

  Address: 172.16.33.12
  Ranges: 192.168.56.0/21

Valid ranges can be modified in the /etc/vbox/networks.conf file. For
more information including valid format see:

  https://www.virtualbox.org/manual/ch06.html#network_hostonly
```
```bash
sudo mkdir /etc/vbox
```
```bash
sudo echo "* 0.0.0.0/0 ::/0" | sudo tee /etc/vbox/networks.conf
```

**basic**

- up

```bash
bash basic.sh -up
```

- destroy

```bash
bash basic.sh -destroy
```

**mult-servers**

- up

```bash
bash mult.sh -up
```

- destroy

```bash
bash mult.sh -destroy
```


**mult-servers-ha**

- up

```bash
bash mult_ha.sh -up
```

- destroy

```bash
bash mult_ha.sh -destroy
```


## Licença
![Badge](https://img.shields.io/badge/license-GPLv3-green)
