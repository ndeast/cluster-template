#!/bin/bash
yum install -y nfs-utils

mkdir -p /mnt/nfs/software
mount -t nfs 192.168.1.1:/software /mnt/nfs/software
touch /mnt/nfs/software/test_nfs_file