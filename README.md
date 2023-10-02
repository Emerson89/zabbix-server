# Instalação Zabbix-server usando ansible

![Badge](https://img.shields.io/badge/ansible-zabbix-red)

## Dependências
![Badge](https://img.shields.io/badge/ansible-2.9.10-blue)

## Suporte SO

- Ubuntu20
- Ubuntu22
- Debian11
- Rocky8
- Almalinux8
- Centos8

## Versões suportadas zabbix

| Versões Zabbix |  Debian 11 | Ubuntu 20 | Ubuntu 22 | Rocky 8 | Almalinux 8 | Centos 8 |
|   ----         |     ---    |    ---    |    ---    |   ---   |     ---     |    ---   |
|    4.4         |      No    |     Yes   |      No   |   Yes   |       Yes   |    Yes   |
|    5.0         |      Yes   |     Yes   |      No   |   Yes   |       Yes   |    Yes   |
|    5.2         |      Yes   |     Yes   |      No   |   Yes   |       Yes   |    Yes   |
|    5.4         |      Yes   |     Yes   |      No   |   Yes   |       Yes   |    Yes   |
|    6.0         |      Yes   |     Yes   |      Yes  |   Yes   |       Yes   |    Yes   |
|    6.4         |      Yes   |     Yes   |      Yes  |   Yes   |       Yes   |    Yes   |
|    6.5         |      Yes   |     Yes   |      Yes  |   Yes   |       Yes   |    Yes   |

Suporte a banco de dados MySQL e Postgresql com timescaledb

Para limitar uso de espaço em disco pelo arquivo de log binlog do mysql que por default é 30 dias para expurgo você pode reduzir no banco com comando abaixo:
```
show variables like '%expire_logs%';
SET GLOBAL binlog_expire_logs_seconds = (60*60*24*10);
```
60*60*24*10 = 864000 

Segundos para Dias

dias = segundos / 86400

dias = 864000 / 86400

dias = 10
#
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
| zbx_server_ha | IP zabbix node 2 **(Somente para versão 6.0 ou acima)** | 127.0.0.1
| zabbix_server_ha | habilita o HA **(Somente para a Versão 6.0 ou acima)** enable|disable | disable
| mysql_root_pass | password user root **mysql** | Tg0z64OVddNzFwNA==
| db_zabbix_pass | password user zabbix **mysql** | Tg0z64OVddNzFwNA==
| postgresql_version | versão postgresql | 13
| zabbix_database_partition | habilita particionamento **mysql** | false
| history_days | history em dias para realizar o particionamento **mysql** | 13
| trends_month | thends em mes para realizar o particionamento **mysql** | 2

## Exemplo de playbook para instalação em localhost Mysql (DEFAULT)
```yaml
---
- hosts: all
  become: true
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
  roles:
    - {role: roles/mysql}
    - {role: roles/zabbix-server}
    - {role: roles/zabbix-front}
```
OBS: 
 - Navegue até o frontend do Zabbix e vá para Administration | Housekeeping.
 - Certifique-se de que Enable internal housekeeping esteja desligado para History e Trends.

Para validar o partiticionamento acesse o banco

```
use zabbix;
show create table history;
```

## Exemplo de playbook para instalação em localhost postgresql
```yaml
---
- hosts: all
  become: true
  vars:
    zabbix_server_database: pgsql
    zabbix_server_database_long: pgsql
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
```yaml
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
```yaml
[db]
IP-DATABASE ansible_ssh_private_key_file=PATH/private_key ansible_user=vagrant
[zabbix]
IP-ZABBIX_SERVER ansible_ssh_private_key_file=PATH/private_key ansible_user=vagrant
IP-ZABBIX_SERVER-NODE2 ansible_ssh_private_key_file=PATH/private_key ansible_user=vagrant
[web]
IP_FRONT ansible_ssh_private_key_file=PATH/private_key ansible_user=vagrant
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

```ruby
vms = {
#'rocky-srv' => {'memory' => '2024', 'cpus' => '1', 'ip' => '11', 'box' => 'rockylinux/8'},
'almalinux-srv' => {'memory' => '1024', 'cpus' => '1', 'ip' => '12', 'box' => 'almalinux/8'},
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
