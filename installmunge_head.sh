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
sudo chown munge: /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key 

sudo cp /etc/munge/munge.key /scratch/munge.key

sudo chown -R munge: /etc/munge/ /var/log/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/

sudo systemctl enable munge
sudo systemctl start munge


yum install openssl openssl-devel pam-devel numactl numactl-devel hwloc hwloc-devel lua lua-devel readline-devel rrdtool-devel ncurses-devel man2html libibmad libibumad -y

cd /software
sudo wget http://www.schedmd.com/download/latest/slurm-18.08.3.tar.bz2
sudo yum install rpm-build

#install perl due to dependancy
sudo yum install perl -y
sudo yum install 'perl(ExtUtils::MakeMaker)' -y

sudo rpmbuild -ta slurm-18.08.3.tar.bz2

#create slurm-rpm directory and copyt rpmbuild into it
sudo mkdir /software/slurm-rpms
sudo cp /root/rpmbuild/RPMS/x86_64/* /software/slurm-rpms

sudo yum --nogpgcheck localinstall /software/slurm-rpms/* -y

#sudo cp /scratch/slurm.conf /etc/slurm/slurm.conf
sudo mkdir /var/spool/slurmctld
sudo chown slurm: /var/spool/slurmctld
sudo chmod 755 /var/spool/slurmctld
sudo touch /var/log/slurmctld.log
sudo chown slurm: /var/log/slurmctld.log
sudo touch /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log
sudo chown slurm: /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log
#sudo touch /var/run/slurmctld
#sudo chmod 777 /var/run/slurmctld

sudo yum install ntp -y
sudo chkconfig ntpd on
sudo ntpdate pool.ntp.org
sudo systemctl start ntpd

systemctl enable slurmd.service
systemctl start slurmd.service
systemctl status slurmd.service

#sudo touch /scratch/head.fin
#sudo systemctl restart slurmctld

