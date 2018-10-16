#!/bin/bash
sudo yum -y install nfs-utils
mkdir /software

chmod -R 755 /software

echo "/software 192.168.1.4(rw,sync,no_root_squash,no_all_squash)" > /etc/exports
echo "/software 192.168.1.5(rw,sync,no_root_squash,no_all_squash)" >> /etc/exports
echo "/software 192.168.1.6(rw,sync,no_root_squash,no_all_squash)" >> /etc/exports

systemctl restart nfs-server

mkdir -p /mnt/nfs/scratch
mount -t nfs 192.168.1.3:/scratch /mnt/nfs/scratch
touch /mnt/nfs/software/test_nfs_file_head_scratch

