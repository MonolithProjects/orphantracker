# orphantracker

Script helps to identify orphaned VMs in the OpenStack.  
It runs trough all VMs and checks if they are assigned to an existing Openstack Project/Tenant.  
Result will be a list of orphaned VMs. Script will NOT delete any VM.


# Usage

Install `openstack` client and just load your `openrc` file for user with `admin role` and run the script.

# Usage and output example

```
$ ./orphantracker.sh
Searching for orphaned VMs...
Checked 2 of total 2 VMs...

I have found 2 orphaned VMs:
+----------------------------------+--------------------------------------+------------------------------+
| Project ID                       | VirtualMachine ID                    | VirtualMachine Name          |
+----------------------------------+--------------------------------------+------------------------------+
| 3c4c71840ea0407dabdb22b72bc50f12   40eca4a7-0696-41a0-9ca4-1a0bdd0e778a   virtual-machine_RedHatEnt... |
| 3c4c71840ea0407dabdb22b72bc50f12   f47de21a-9005-4b38-87dc-07497261a82e   testVM_db                    |
+----------------------------------+--------------------------------------+------------------------------+

```
