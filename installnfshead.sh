#!/bin/bash
sudo yum -y install nfs-utils
mkdir /var/nfsshare

chmod -R 755 /var/nfsshare
chown nfsnobody:nfsnobody /var/nfsshare