#!/bin/bash

echo "Enter a new root password: "
passwd

echo "Enter a password for the 'ansible' user:"
useradd -d /home/ansible -m ansible
passwd ansible

echo "Generating ssh keys for the 'ansible' user:"
su - ansible -c "ssh-keygen -t ed25519 -N '' -f ~/.ssh/id_ed25519"

echo "Adding 'ansible' user to sudoers..."
echo 'ansible ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/ansible

firewall-cmd --new-zone=httpd-access --permanent
firewall-cmd --zone=httpd-access --add-source=192.168.0.0/16 --permanent
firewall-cmd --zone=httpd-access --add-port=80/tcp --permanent
firewall-cmd --reload

dnf update -y
dnf install ansible-core httpd -y 
mkdir -p /var/www/html/autoinstall
mkdir -p /var/www/html/public-keys
rsync -rav /home/ansible/.ssh/id_ed25519.pub /var/www/html/public-keys/.
systemctl enable --now httpd

reboot
