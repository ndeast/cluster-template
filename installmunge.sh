#!/bin/bash 
set -x 

#create global users
export MUNGEUSER=991
sudo groupadd -g $MUNGEUSER munge
sudo useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SLURMUSER=992
sudo groupadd -g $SLURMUSER slurm
sudo useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm

sudo yum install epel-release
sudo yum install munge munge-libs munge-devel -y

/usr/sbin/create-munge-key 

sudo bash -c "echo "key" > /etc/munge/munge.key"
chown munge: /etc/munge/munge.key
sudo chmod 700 /etc/munge/munge.key 

for i in {1..3}; do
sudo scp /etc/munge/munge.key ne903386@192.168.1.$i:~/
sudo ssh -t ne903386@192.168.1.$i sudo cp ~/munge.key /etc/munge; sudo chmod 700 /etc/munge/munge.key; chown munge: /etc/munge/munge.key
done



