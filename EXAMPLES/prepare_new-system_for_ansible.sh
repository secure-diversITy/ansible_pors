#!/bin/bash
########################################################################
# - create user
# - set sudo perms
# - allow ansible ssh access with key
########################################################################

ANSIBLEUSR=ansible

read -p "This has to be executed on the server to be connected - NOT on the ansible server" ENTER

echo "Creating ansible user ($ANSIBLEUSR):"

useradd $ANSIBLEUSR -U -m -G wheel

echo -e "# Ansible management for the splunk> platform\n$ANSIBLEUSR\tALL=(ALL)\tNOPASSWD: ALL\n" > /etc/sudoers.d/ansible-admin-root
chmod 440 /etc/sudoers.d/ansible-admin-root

mkdir /home/$ANSIBLEUSR/.ssh

read -p "now paste in (press i before) the ansible pub key in the next step" ENTER
vim /home/$ANSIBLEUSR/.ssh/authorized_keys

chown -R $ANSIBLEUSR:$ANSIBLEUSR /home/$ANSIBLEUSR/.ssh
chmod 700 /home/$ANSIBLEUSR/.ssh
chmod 600 /home/$ANSIBLEUSR/.ssh/authorized_keys
passwd -x 999999999999 $ANSIBLEUSR


echo "The ansible pipelining acceleration requires to disable requiretty in sudoers"
echo "While it is not necessary it speed ups things by factor 10"
read -p "Ensure the line: 'Defaults requiretty' is outcommented on the next screen" ENTER
sed 's/^Defaults requiretty/##Defaults requiretty/g' -i /etc/sudoers
visudo

read -p "Now open another shell and test sudo before proceeding!" ENTER

echo -e 'Removing splunk permissions if needed\n'
[ -f /etc/sudoers.d/splunk-admin-root ] && rm -vf /etc/sudoers.d/splunk-admin-root

echo All done.
