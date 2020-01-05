#!/bin/bash -x
# use a different volsize each time you run this, or modify
# this script to include a prefix to keep from clobbering the names
# ater this runs, you can create the PVs by changing to the YAML_FILES_DIR and using
# a "for i in * ; do oc create -f $i ; done" loop

export NFS_SERVER="helper2.ocp.example.com"
export volsize="2Gi"
export NUM_VOLUMES=10
export YAML_FILES_DIR="/root/pvs"

mkdir -p $YAML_FILES_DIR

for pvnum in $(seq 1 $NUM_VOLUMES); do mkdir -p /exports/user-vols/"${volsize}${pvnum}" ; done

for pvnum in  $(seq 1 $NUM_VOLUMES) ; do echo "/exports/user-vols/${volsize}${pvnum} *(rw,root_squash)" >> /etc/exports.d/openshift-uservols.exports ; 
done
chown -R nfsnobody.nfsnobody  /exports
chmod -R 777 /exports

systemctl restart nfs-server


for volume in $(seq 1 $NUM_VOLUMES);  do cat << ENDJASON > /$YAML_FILES_DIR/${volsize}-${volume}.yml ; done 
{
  "apiVersion": "v1",
  "kind": "PersistentVolume",
  "metadata": {
    "name": "pv-$( echo ${volsize} | tr '[:upper:]' '[:lower:]')-${volume}"
  },
  "spec": {
    "capacity": {
        "storage": "${volsize}"
    },
    "accessModes": [ "ReadWriteOnce" ],
    "nfs": {
        "path": "/exports/user-vols/${volsize}${volume}",
        "server": "$NFS_SERVER"
    },
    "persistentVolumeReclaimPolicy": "Recycle"
  }
}
ENDJASON

