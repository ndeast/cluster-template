#!/bin/bash 

#create global users
export MUNGEUSER=991
sudo groupadd -g $MUNGEUSER munge
sudo useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SLURMUSER=992
sudo groupadd -g $SLURMUSER slurm
sudo useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm

sudo yum install epel-release
sudo yum install munge munge-libs munge-devel -y

while [ ! -f /scratch/munge.key]
do
    sleep 10s
done

sudo cp /scratch/munge.key /etc/munge/munge.key
sudo chown munge: /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key

sudo chown -R munge: /etc/munge/ /var/log/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/

while [ ! -f /scratch/metafinish.done]
do
    sleep 10s
done

sudo systemctl enable munge
sudo systemctl start munge


#installing slurm
sudo yum install openssl openssl-devel pam-devel numactl numactl-devel hwloc hwloc-devel lua lua-devel readline-devel rrdtool-devel ncurses-devel man2html libibmad libibumad -y

sudo yum --nogpgcheck localinstall /software/slurm-rpms/* -y

while [ ! -f /scratch/rpm.done]
do
    sleep 10s
done

sudo cp /scratch/slurm.conf /etc/slurm/slurm.conf
sudo mkdir /var/spool/slurmd
sudo chown slurm: /var/spool/slurmd
sudo chmod 755 /var/spool/slurmd
sudo touch /var/log/slurmd.log
sudo chown slurm: /var/log/slurmd.log

sudo systemctl stop firewalld
sudo systemctl disable firewalld

sudo yum install ntp -y
sudo chkconfig ntpd on
sudo ntpdate pool.ntp.org
sudo systemctl start ntpd

while [ ! -f /scratch/database.done]
do
    sleep 10s
done

sudo systemctl enable slurmd
sudo systemctl start slurmd

sudo touch /scratch/daemon.done

