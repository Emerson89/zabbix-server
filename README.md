# Instalação zabbix-server 5.0 usando ansible

![Badge](https://img.shields.io/badge/ansible-zabbix-red)
![Badge](https://img.shields.io/badge/aws-zabbix-red)
![Badge](https://img.shields.io/badge/zabbix-5.0-red)

## Dependências
![Badge](https://img.shields.io/badge/ansible-2.9.10-blue)
![Badge](https://img.shields.io/badge/CentOS-8-blue)

## Edite o arquivo hosts para ip do host destino

## Para usar o apache use a v1.1

## Exemplo de playbook
```
---
- name: Install Zabbix Server
  hosts: all
  become: yes
  roles:
  - zabbix-server
```
``` 
ansible-playbook -i hosts zabbix.yml
``` 
## Licença
![Badge](https://img.shields.io/badge/license-GPLv3-green)
