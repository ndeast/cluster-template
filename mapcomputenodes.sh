#!/bin/bash
yum install -y nfs-utils

mkdir -p /mnt/nfs/software
mkdir -p /mnt/nfs/scratch
mount -t nfs 192.168.1.1:/software /mnt/nfs/software
mount -t nfs 192.168.1.3:/scratch /mnt/nfs/scratch
touch /mnt/nfs/software/test_nfs_file
touch /mnt/nfs/software/test_nfs_file_scratch

echo "export PATH='$PATH:/mnt/nfs/software/openmpi/3.1.2/bin'" >> /users/ne903386/.bashrc
echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/mnt/nfs/software/openmpi/3.1.2/lib/'" >> /users/ne903386/.bashrc



