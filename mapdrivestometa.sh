#! /bin/bash

mkdir -p /software
mkdir -p /scratch
mount -t nfs 192.168.1.1:/software /software
mount -t nfs 192.168.1.3:/scratch /scratch
touch /scratch/test_nfs_file_meta
touch /software/test_nfs_file_meta