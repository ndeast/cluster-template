#!/bin/bash
sudo yum -y install nfs-utils
mkdir /scratch

chmod -R 755 /scratch

echo "/scratch 192.168.1.1(rw,sync,no_root_squash,no_all_squash)" > /etc/exports
echo "/scratch 192.168.1.4(rw,sync,no_root_squash,no_all_squash)" > /etc/exports
echo "/scratch 192.168.1.5(rw,sync,no_root_squash,no_all_squash)" >> /etc/exports
echo "/scratch 192.168.1.6(rw,sync,no_root_squash,no_all_squash)" >> /etc/exports

systemctl restart nfs-server


