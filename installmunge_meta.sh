#!/bin/bash

yum install mariadb-server mariadb-devel -y

export MUNGEUSER=991
sudo groupadd -g $MUNGEUSER munge
sudo useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SLURMUSER=992
sudo groupadd -g $SLURMUSER slurm
sudo useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm

sudo yum install epel-release -y
sudo yum install munge munge-libs munge-devel -y

sudo cp /scratch/munge.key /etc/munge/munge.key
sudo chown munge: /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key

sudo chown -R munge: /etc/munge/ /var/log/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/

#sudo touch /scratch/metakey.fin

sudo systemctl enable munge
sudo systemctl start munge


#install slurm
sudo yum install openssl openssl-devel pam-devel numactl numactl-devel hwloc hwloc-devel lua lua-devel readline-devel rrdtool-devel ncurses-devel man2html libibmad libibumad -y

sudo yum --nogpgcheck localinstall /software/slurm-rpms/* -y

sudo mkdir /var/spool/slurmdbd
sudo chown slurm: /var/spool/slurmdbd
sudo chmod 755 /var/spool/slurmdbd
sudo touch /var/log/slurmdbd.log
sudo chown slurm: /var/log/slurmdbd.log
sudo chmod 755 /var/log/slurmdbd.log
#sudo touch /var/run/slurmdbd.pid
#sudo chown slurm: /var/run/slurmdbd.pid
#sudo chmod 777 /var/run/slurmdbd.pid

sudo yum install ntp -y
sudo chkconfig ntpd on
sudo ntpdate pool.ntp.org
sudo systemctl start ntpd

sudo systemctl enable slurmdbd
sudo systemctl start slurmdbd


