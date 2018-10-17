#!/bin/bash
sudo yum -y install nfs-utils
mkdir /software

chmod -R 755 /software

for i in {4..15}; do
    echo "/software 192.168.1.$i(rw,sync,no_root_squash,no_all_squash)" >> /etc/exports
done

systemctl restart nfs-server

mkdir -p /mnt/nfs/scratch
mount -t nfs 192.168.1.3:/scratch /mnt/nfs/scratch
touch /mnt/nfs/scratch/test_nfs_file_head_scratch

