#!/bin/sh

oc import-image nodejs-8-rhel7 \
    --from=registry.access.redhat.com/rhscl/nodejs-8-rhel7 --confirm