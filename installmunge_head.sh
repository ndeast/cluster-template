#!/bin/bash 
set -x 

#create global users
export MUNGEUSER=991
sudo groupadd -g $MUNGEUSER munge
sudo useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER -g munge  -s /sbin/nologin munge
export SLURMUSER=992
sudo groupadd -g $SLURMUSER slurm
sudo useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER -g slurm  -s /bin/bash slurm

#install EPEL repository
sudo yum install epel-release

#intall munge
sudo yum install munge munge-libs munge-devel -y

/usr/sbin/create-munge-key 

#creating a key
sudo bash -c "echo "key" > /etc/munge/munge.key"
sudo chown munge: /etc/munge/munge.key
sudo chmod 400 /etc/munge/munge.key 

#sending key to scratch directory
sudo cp /etc/munge/munge.key /scratch/munge.key

#change permissions
sudo chown -R munge: /etc/munge/ /var/log/munge/
sudo chmod 0700 /etc/munge/ /var/log/munge/

#wait while all nodes have installed and recieve secret key
while [! -f /scratch/metafinish.done]
do 
sleep 10s
done

#start munge
sudo systemctl enable munge
sudo systemctl start munge

#install Slurm dependancies
yum install openssl openssl-devel pam-devel numactl numactl-devel hwloc hwloc-devel lua lua-devel readline-devel rrdtool-devel ncurses-devel man2html libibmad libibumad -y

#download latest version of slurm
cd /software
sudo wget http://www.schedmd.com/download/latest/slurm-18.08.3.tar.bz2
sudo yum install rpm-build

#install perl
sudo yum install perl -y
sudo yum install 'perl(ExtUtils::MakeMaker)' -y

#install rpmbuild
sudo rpmbuild -ta slurm-18.08.3.tar.bz2

#create slurm-rpm directory and copyt rpmbuild into it
sudo mkdir /software/slurm-rpms
sudo cp /root/rpmbuild/RPMS/x86_64/* /software/slurm-rpms

sudo yum --nogpgcheck localinstall /software/slurm-rpms/* -y

#copy the slurm.conf file over
sudo cp /scratch/slurm.conf /etc/slurm/slurm.conf

#configuration
sudo mkdir /var/spool/slurmctld
sudo chown slurm: /var/spool/slurmctld
sudo chmod 755 /var/spool/slurmctld
sudo touch /var/log/slurmctld.log
sudo chown slurm: /var/log/slurmctld.log
sudo touch /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log
sudo chown slurm: /var/log/slurm_jobacct.log /var/log/slurm_jobcomp.log
#sudo touch /var/run/slurmctld
#sudo chmod 777 /var/run/slurmctld

#install sync clock
sudo yum install ntp -y
sudo chkconfig ntpd on
sudo ntpdate pool.ntp.org
sudo systemctl start ntpd

while [! -f /scratch/daemon.done]
do
sleep 5s
done

systemctl enable slurmd.service
systemctl start slurmd.service
systemctl status slurmd.service

#notify meta that slurmctld daemon done
sudo touch /scratch/slurmctlddaemon.done

while [! -f /scratch/cluster.done]
do
sleep 5s
done

sudo systemctl restart slurmctld

