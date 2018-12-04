#!/bash/bin 
set -x 

sudo yum install epel-release
sudo yum install munge munge-libs munge-devel -y

/usr/sbin/create-munge-key 

sudo bash -c "echo "key" > /etc/munge/munge.key"
chown munge: /etc/munge/munge.key
sudo chmod 700 /etc/munge/munge.key 

for i in {1..3}; do
scp /etc/munge/munge.key ne903386@192.168.1.$i:/etc/munge
ssh -t ne903386@192.168.1.$i sudo chmod 700 /etc/munge/munge.key 
done



