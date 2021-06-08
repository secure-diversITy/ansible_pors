#!/bin/bash

src="$1"
dest="$2"
env="$3"

if [ ! -d "${src}" ]||[ ! -d "${dest}" ]||[ -z "${env}" ];then
    echo "missing arg!"
    echo "$0 src-path dest-path env-name"
    exit 3
fi

# migrate to site aware vars

for a in $(find ${src}/inventories/${env}/group_vars/heavyforwarder/ -type f -exec grep clean_install {} \; -print0 | cut -d " " -f1);do cp -v $a ${dest}/inventories/${env}/group_vars/site1_heavyforwarder/; done
for a in $(find ${src}/inventories/${env}/group_vars/deployer/ -type f -exec grep clean_install {} \; -print0 | cut -d " " -f1);do cp -v $a ${dest}/inventories/${env}/group_vars/site1_deployer/; done

# migrate any other

for a in $(find ${src}/inventories/${env}/group_vars/ -mindepth 1 -maxdepth 1 -type d | egrep -v "/all$|/heavyforwarder$|/deployer$");do
    d="${a##/*\/}"
    for ar in $(find $a -type f -exec grep clean_install {} \; -print0 | cut -d " " -f1);do
        cp -v $ar ${dest}/inventories/${env}/group_vars/$d
    done
done
