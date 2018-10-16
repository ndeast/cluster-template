#!/bin/bash
sudo yum -y install nfs-utils
mkdir /scratch

chmod -R 755 /scratch

echo "/scratch 192.168.1.1(rw,sync,no_root_squash,no_all_squash)" > /etc/exports
for i in {4..15}; do
    echo "/scratch 192.168.1.$i(rw,sync,no_root_squash,no_all_squash)" > /etc/exports
done

systemctl restart nfs-server


