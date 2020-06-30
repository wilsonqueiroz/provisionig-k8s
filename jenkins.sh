#!/bin/sh

oc import-image jenkins:289 \
    --from=registry.access.redhat.com/openshift3/jenkins-2-rhel7:v3.7.23-10 --confirm

oc new-app jenkins-persistent --param ENABLE_OAUTH=true \
    --param MEMORY_LIMIT=512Mi --param VOLUME_CAPACITY=4Gi 
    #--param JENKINS_IMAGE_STREAM_TAG=cicd-jenkins:2
