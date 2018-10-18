#!/bin/bash
yum install -y nfs-utils

mkdir -p /software
mkdir -p /scratch
mount -t nfs 192.168.1.1:/software /software
mount -t nfs 192.168.1.3:/scratch /scratch
touch /software/test_nfs_file
touch /software/test_nfs_file_scratch

echo "export PATH='$PATH:/software/openmpi/3.1.2/bin'" >> /users/ne903386/.bashrc
echo "export LD_LIBRARY_PATH='$LD_LIBRARY_PATH:/software/openmpi/3.1.2/lib/'" >> /users/ne903386/.bashrc




