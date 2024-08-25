#!/bin/bash


#!/bin/bash

UP=$2
DESTROY=$2

cd mult_servers_ha

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -up)
            UP="$2"
            vagrant up
            exit 1
            ;;
        -destroy)
            DESTROY="$2"
            vagrant destroy -f
            exit 1
            ;;
        *)
            echo "unknown parameter: $1"
            exit 1
            ;;
    esac
done