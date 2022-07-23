#!/bin/bash

DOCKER_CONTAINER_NAME="rocky"
DOCKER_IMAGE="emr001/rocky-emr"
INIT=/usr/lib/systemd/systemd
RUN_OPTS="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"  

docker run -ti $RUN_OPTS --detach --volume="${PWD}":/etc/ansible/roles/role_under_test:ro -p 8080:80 --name $DOCKER_CONTAINER_NAME $DOCKER_IMAGE $INIT

docker exec $DOCKER_CONTAINER_NAME ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml --extra-vars "zabbix_version=4.4 zabbix_server_database_long=mysql zabbix_server_database=mysql"

docker exec -it $DOCKER_CONTAINER_NAME /bin/bash

docker stop $DOCKER_CONTAINER_NAME

docker rm $DOCKER_CONTAINER_NAME
