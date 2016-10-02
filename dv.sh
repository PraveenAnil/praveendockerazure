#!/bin/bash

envprefix="vm"

rg='rg'
for (( j=1; n <= 2 ; j++ ))
do
  std=std$j
  touch /opt/ip$envprefix$std$rg.txt
  echo $(az network public-ip list -g $envprefix$std$rg |grep "domainNameLabel\|ipAddress\|fqdn") > /opt/ip$envprefix$std$rg.txt
 
done
