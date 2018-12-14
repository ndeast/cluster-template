# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg
import geni.rspec.igext as IG

# Create a portal context.
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()


tourDescription = \
"""
This profile provides the template for a full research cluster with head node, scheduler, compute nodes, and shared file systems.
First node (head) should contain: 
- Shared home directory using Networked File System
- Management server for SLURM
Second node (metadata) should contain:
- Metadata server for SLURM
Third node (storage):
- Shared software directory (/software) using Networked File System
Remaining three nodes (computing):
- Compute nodes  
"""

#
# Setup the Tour info with the above description and instructions.
#  
tour = IG.Tour()
tour.Description(IG.Tour.TEXT,tourDescription)
request.addTour(tour)

prefixForIP = "192.168.1."

link = request.LAN("lan")

for i in range(6):
  if i == 0:
    node = request.XenVM("head")
    node.routable_control_ip = "true"
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/installnfshead.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/installnfshead.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/install_mpi.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/install_mpi.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/installmunge_head.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/installmunge_head.sh"))
  elif i == 1:
    node = request.XenVM("metadata")
    node.addService(pg.Execute(shell="sh", command="sudo yum -y install nfs-utils"))
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/mapdrivestometa.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/mapdrivestometa.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo cp /local/repository/createsql.sh /scratc/createsql.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/installmunge_meta.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/installmunge_meta.sh"))

  elif i == 2:
    node = request.XenVM("storage")
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/installnfsstorage.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/installnfsstorage.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo cp /local/repository/slurm.conf /scratch/slurm.conf"))
    node.addService(pg.Execute(shell="sh", command="sudo cp /local/repository/slurmdbd.conf /scratch/slurmdbd.conf"))
  else:
    node = request.XenVM("compute-" + str(i-2))
    node.cores = 4
    node.ram = 4096
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/installmunge_comp.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/installmunge_comp.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/mapcomputenodes.sh"))
    node.addService(pg.Execute(shell="sh", command="sudo /local/repository/mapcomputenodes.sh"))
    
  node.disk_image = "urn:publicid:IDN+emulab.net+image+emulab-ops:CENTOS7-64-STD"
  
  iface = node.addInterface("if" + str(i))
  iface.component_id = "eth1"
  iface.addAddress(pg.IPv4Address(prefixForIP + str(i + 1), "255.255.255.0"))
  link.addInterface(iface)
  
  node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/passwordless.sh"))
  node.addService(pg.Execute(shell="sh", command="sudo /local/repository/passwordless.sh"))
  
  # This code segment is added per Benjamin Walker's solution to address the StrictHostKeyCheck issue of ssh
  node.addService(pg.Execute(shell="sh", command="sudo chmod 755 /local/repository/ssh_setup.sh"))
  node.addService(pg.Execute(shell="sh", command="sudo -H -u ne903386 bash -c '/local/repository/ssh_setup.sh'"))
 
  node.addService(pg.Execute(shell="sh", command="sudo su ne903386 -c 'cp /local/repository/source/* /users/ne903386'"))
  
# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)
