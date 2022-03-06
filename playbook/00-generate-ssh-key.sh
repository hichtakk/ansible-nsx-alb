#!/bin/sh

set -xe

SSHKEY_DIR=sshkey
ssh-keygen -q -P "" -C "" -t rsa -b 2048 -f ./${SSHKEY_DIR}
