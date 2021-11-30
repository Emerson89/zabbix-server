#!/bin/bash

DOCKER_CONTAINER_NAME="centos"
DOCKER_IMAGE="centos8"
INIT=/usr/lib/systemd/systemd
RUN_OPTS="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"  

docker build -t $DOCKER_IMAGE --rm=true --file=tests/Dockerfile.$DOCKER_CONTAINER_NAME tests

docker run -ti $RUN_OPTS --detach --volume="${PWD}":/etc/ansible/roles/role_under_test:ro --name $DOCKER_CONTAINER_NAME $DOCKER_IMAGE $INIT

docker exec $DOCKER_CONTAINER_NAME ansible-playbook /etc/ansible/roles/role_under_test/tests/test.yml --extra-vars "zabbix_version=4.4"

#docker exec -it $DOCKER_CONTAINER_NAME /bin/bash
docker stop $DOCKER_CONTAINER_NAME

docker rm $DOCKER_CONTAINER_NAME

docker rmi $DOCKER_IMAGE