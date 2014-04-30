# phoros-vm

A vagrant virtual machine using VirtualBox to run the phoros servlet. 

## Requirements ##

- VirtualBox: <https://www.virtualbox.org/>
- Vagrant: <http://www.vagrantup.com/>
- a terminal or shell for starting you virtual machine from the command line 


## Strongly recommended ##

The VirtualBox Guest Additions for Vagrant.  After installing vagrant, you can install the guest additions by running from the root directory of this repository:

    vagrant plugin install vagrant-vbguest

## Usage ##

Open a terminal session to the virtual machine, and 

    vagrant ssh

from prompt there:

    sh /vagrant/phoros.sh
    

8080 on VM forwarded to 8888 on host

Point you browser at: `http://localhost:8888/phoros` (or so)

