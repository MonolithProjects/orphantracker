# orphantracker

Script which helps identify orphaned VMs in the OpenStack.  
It runs trough all VMs and checks if they are assigned to existing Openstack Project/Tenant.  
Result will be a list of orphaned VMs.


# Usage

Just load your `openrc` file for user with `admin role` and run the script.

# Usage and output example

```
$ ./orphantracker.sh 
Searching for orphaned VMs...
Checked 2 of total 2 VMs... 
I have found 2 orphaned VMs.
Please check them. In case they are really orphaned, please delete them.
+----------------------------------+--------------------------------------+
| Project ID                       | VirtualMachine ID                    |
+----------------------------------+--------------------------------------+
| 3c4c71840ea0407dabdb22b72bc50f12   e971dfa5-dd1f-48e0-8b8b-599afa1e491a |
| 3c4c71840ea0407dabdb22b72bc50f12   afe71262-4eff-4ef3-a45f-32edba93b547 |
+----------------------------------+--------------------------------------+
```