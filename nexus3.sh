#!/bin/sh

#Create new app
oc new-app sonatype/nexus3:latest

sleep 10s

#Expose service
oc expose svc nexus3

#Stop rollout to change
oc rollout pause dc nexus3

sleep 10s

#Change the deployment strategy from rolling to recreate
oc patch dc nexus3 --patch='{ "spec": { "strategy": { "type": "Recreate" }}}'

#Create a Persistent Volume Claim (PVC) and connect it to /nexus-data
echo "apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nexus-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 4Gi" | oc create -f -

#Set up liveness and readiness probes for Nexus
oc set volume dc/nexus3 --add --overwrite --name=nexus3-volume-1 \
    --mount-path=/nexus-data/ --type persistentVolumeClaim \
    --claim-name=nexus-pvc

#Add nexus probes 1
oc set probe dc/nexus3 --liveness --failure-threshold 3 \
    --initial-delay-seconds 180 -- echo ok

#Adding nexus probes 2
oc set probe dc/nexus3 --readiness --failure-threshold 3 \
    --initial-delay-seconds 180 --get-url=http://:8081/repository/maven-public/

#Once Nexus is deployed, set up Red Hat repositories using the default user ID (admin) and password (admin123).
oc rollout resume dc nexus3