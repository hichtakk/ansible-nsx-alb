#!/bin/sh

set -x

SSHKEY=./sshkey
PASSWORD=VMware1!

# deploy controller ova
source ./govcrc
for ctrl in controller01 controller02 controller03; do
    govc import.ova --options ./${ctrl}.json ./controller-21.1.3-9051.ova
done

# set admin password
for ctrl in 192.168.111.208 192.168.111.209 192.168.111.210; do
    ssh -o 'StrictHostKeyChecking no' -i ${SSHKEY} admin@${ctrl} "sudo /opt/avi/scripts/initialize_admin_user.py --password ${PASSWORD}"
    while test $? -gt 0; do
        echo "Controller (${ctrl}) is not ready yet. retry in 10 sec."
        sleep 10
        ssh -o 'StrictHostKeyChecking no' -i ${SSHKEY} admin@${ctrl} "sudo /opt/avi/scripts/initialize_admin_user.py --password ${PASSWORD}"
    done
done
