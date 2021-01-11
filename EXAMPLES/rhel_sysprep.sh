#!/bin/bash
######################################################################
#
# Copyright 2017-2020: T. Fischer <mail -at- sedi -dot- one>
#
# System preparartion for RHEL/CentOS after cloning
#
######################################################################
VERSION="1.7"

LOG="${0}.log"

F_HELP(){
 echo -e "\nVersion: $VERSION\n"
 echo -e "$0 <short-hostname-template> <short-hostname-new> <fqdn-new>\n\n"
 echo
 echo -e "Example:\n"
 echo -e "\t$0 vm-tmpl mynewvm mynewvm.domain.local\n"
}

if [ $# -lt 3 ];then
 echo "Missing argument!"
 F_HELP
 exit
fi

TEMPLHOST="$1"
HOSTNAME=$2
FQDN="$3"

hostname $FQDN
echo $HOSTNAME > /etc/hostname

# backup all files we change here
 [ -d ~/backup ] || mkdir ~/backup
cp /etc/sysconfig/network-scripts/ifcfg-eth0  ~/backup/ifcfg-eth0_$(date +%s)
cp /etc/hosts ~/backup/hosts_$(date +%s)
cp /etc/nslcd.conf ~/backup/nslcd.conf_$(date +%s)
cp /etc/machine-id ~/backup/machine-id_$(date +%s)
cp /etc/NetworkManager/NetworkManager.conf ~/backup/NetworkManager.conf_$(date +%s)  >> /dev/null 2>&1

# ensure hostname is set in nscld
grep "host=$HOSTNAME" /etc/nslcd.conf >> /dev/null
if [ $? -ne 0 ];then 
    sed -i "s/$TEMPLHOST/$HOSTNAME/g;s/$TEMPLIP/$IP/g" /etc/nslcd.conf
fi

# remove conflicting network manager conf if exists
[ -f /etc/NetworkManager/NetworkManager.conf ] && rm /etc/NetworkManager/NetworkManager.conf -f

# # regenerate the machine id
rm -f /etc/machine-id
systemd-machine-id-setup

# clean ssh host keys so they get re-generated
rm -rf /etc/ssh/ssh_host_*

# Regenerating initrd image (contains hostname)
echo "regenerate initrd image to add the new hostname. THIS CAN TAKE A WHILE!"
dracut --no-hostonly --force

echo "all done. REBOOT REQUIRED!!!!"


