#!/bin/sh

set -x

# deploy se ova
#source ./govcrc-nest
for se in se01 se02 se03; do
    govc import.ova --options ./${se}.json ./se.ova
done
