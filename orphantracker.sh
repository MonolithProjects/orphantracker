#!/bin/bash
#set -x

# Title          :orphantracker.sh
# Author         :michal.muransky@pan-net.eu
# Version        :0.1
#
# Script will find orphaned VMs in the OpenStack and display a list of them.
# Run this script with OpenStack Admin rights

TEMPFILE="/tmp/vmlist"
OUTPUT="/tmp/outputlist"
ORPHANSCOUNT=0
ORDER=0

# Header of output
cat << EOL > $OUTPUT
+----------------------------------+--------------------------------------+
| Project ID                       | VirtualMachine ID                    |
+----------------------------------+--------------------------------------+
EOL

# Main process
echo "Searching for orphaned VMs..."
openstack server list --all-projects -f json > $TEMPFILE
TOTAL=$(grep .ID $TEMPFILE|wc -l)
while [ $ORDER -lt $(grep .ID $TEMPFILE| wc -l) ]; do
   VM=$(cat $TEMPFILE | jq -r '.['$ORDER'] | .ID')
   ORDER=$((ORDER+1))
   echo -en "\033[0K\rChecked $ORDER of total $TOTAL VMs    "
   echo -en "\033[4D.   "
   PROJECT=$(openstack server show -f json $VM | jq -r ' .project_id')
   echo -en "\033[3D.  "
   sleep .5
   echo -en "\033[2D. "
   if ! openstack project show $PROJECT &> /dev/null ; then
      ORPHANSCOUNT=$((ORPHANSCOUNT+1))
      echo "| $PROJECT   $VM |" >> $OUTPUT
   fi
done

# Output
echo ""
echo "I have found $ORPHANSCOUNT orphaned VMs."
if [ $ORPHANSCOUNT -gt 0 ]; then
   echo "Please check them. In case they are really orphaned, please delete them."
   cat $OUTPUT
   echo "+----------------------------------+--------------------------------------+"
fi
