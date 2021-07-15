#!/bin/sh

curl -u admin:password -H "Content-Type: application/json" -k -d "{\"resetStateFile\": true}" https://54.79.89.174/mgmt/shared/cloud-failover/reset 
curl -u admin:password -H "Content-Type: application/json" -k -d "{\"resetStateFile\": true}" https://3.105.37.222/mgmt/shared/cloud-failover/reset 
