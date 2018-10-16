#!/bin/bash
#set -x

# Title          :orphantracker.sh
# Author         :michal.muransky@pan-net.eu
# Version        :0.2
#
# Script will find orphaned VMs in the OpenStack and display a list of them.
# Run this script with OpenStack admin role

TEMPFILE="/tmp/vmlist"
OUTPUT="/tmp/outputlist"
ORPHANSCOUNT=0
ORDER=0

# Header of output
cat << EOL > $OUTPUT
+----------------------------------+--------------------------------------+------------------------------+
| Project ID                       | VirtualMachine ID                    | VirtualMachine Name          |
+----------------------------------+--------------------------------------+------------------------------+
EOL

# Main process
echo "Searching for orphaned VMs..."
openstack server list --all-projects -f json > $TEMPFILE
TOTAL=$(grep .ID $TEMPFILE|wc -l)
while [ $ORDER -lt $(grep .ID $TEMPFILE| wc -l) ]; do
   VM=$(cat $TEMPFILE | jq -r '.['$ORDER'] | .ID')
   VMNAME=$(cat $TEMPFILE | jq -r '.['$ORDER'] | .Name')
   VMNAME_SIZE=$(printf $VMNAME | wc -m)
   ORDER=$((ORDER+1))
   echo -en "\033[0K\rChecked $ORDER of total $TOTAL VMs"
   if [ $VMNAME_SIZE -ge 28 ] ; then
      VMNAME=$(printf "%.25s\n" $VMNAME)"..."
      SPACE=0
   elif [ $VMNAME_SIZE -lt 28 ] ; then
      SPACE=$(expr 28 - $VMNAME_SIZE)
   fi
   echo -en "\033[4D.   "
   PROJECT=$(openstack server show -f json $VM | jq -r ' .project_id')
   echo -en "\033[3D.  "
   sleep .1
   echo -en "\033[2D. "
   if ! openstack project show $PROJECT &> /dev/null ; then
      ORPHANSCOUNT=$((ORPHANSCOUNT+1))
      s=$(printf "%-${SPACE}s" "")
      if [ $VM != "null" ] ; then
         echo "| $PROJECT   $VM   $VMNAME ${s// / }|" >> $OUTPUT
      fi
   fi
done

# Output
echo ""
echo "I have found $ORPHANSCOUNT orphaned VMs:"
if [ $ORPHANSCOUNT -gt 0 ]; then
   cat $OUTPUT
   echo "+----------------------------------+--------------------------------------+------------------------------+"
fi
