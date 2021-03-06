#!/bin/bash
###This will deploy the required infrastructure on Azure for this workshop##########

### Install JQ - a command line JSON processor to edit the parameter file####
 wget http://stedolan.github.io/jq/download/linux64/jq 
 chmod +x ./jq
 cp jq /usr/bin
 
 ### Get the Deployment template and Parameter file from github#####
 cd /opt/
 wget https://raw.githubusercontent.com/PraveenAnil/praveendockerazure/master/deployazurevm.json
 wget https://raw.githubusercontent.com/PraveenAnil/praveendockerazure/master/deployparam.json 
 touch dep.json
 cd /
 
### Login to Azure Subscription interactively ####

az login

###Non-Fixed Parameter#####

echo "Please enter naming convention prefix - charators only-min 1)"
read envprefix
echo "Please enter number of students for whom resources to be deployed in azure - integer only"
read numberofstudent
echo "Please enter number of docker host(azureVM's) to be created for each student"
read dockerhostperstudent
echo "Please enter azure region resources to be deployed to e.g eastus , westus"
read location
echo "Please enter username -min 6 characters)"
read adminname
echo "Please enter password -min 8 characters-atleast 1 special-1 number)"
read password

###Fixed Parametere ####
rg='rg'
echo $rg
n=1
###Creating resources##
##Starting Outer for loop: this will create ResourceGroup, Network, and storage account##
for (( n=1; n <= $numberofstudent ; n++ ))
do
  std=std$n
  touch /opt/dep$n.json
  cat /opt/deployparam.json >> /opt/dep$n.json
  echo $(jq '.parameters.envnamingprefix.value="'$envprefix'"' /opt/dep$n.json) > /opt/dep$n.json
  echo $(jq '.parameters.stdname.value="'$std'"' /opt/dep$n.json) > /opt/dep$n.json
  echo $(jq '.parameters.dockerhostperstd.value='$dockerhostperstudent'' /opt/dep$n.json) > /opt/dep$n.json
  echo $(jq '.parameters.adminUsername.value="'$adminname'"' /opt/dep$n.json) > /opt/dep$n.json
  echo $(jq '.parameters.adminPassword.value="'$password'"' /opt/dep$n.json) > /opt/dep$n.json
 ###Creating Resource Group for Each Student###
  az resource group create -l $location -n $envprefix$std$rg
  az resource group deployment create --template-file-path /opt/deployazurevm.json --parameters-file-path /opt/dep$n.json -g $envprefix$std$rg --name trialdeplo
done
### Outer Loop Done ###

####Finished Deployment#######
for (( j=1; j <= $numberofstudent ; j++ ))
do
  std=std$j
  touch /opt/ip$envprefix$std$rg.txt
  echo $(az network public-ip list -g $envprefix$std$rg |grep "ipAddress\|fqdn") > /opt/ip$envprefix$std$rg.txt
 
done
echo Deployment finished successfully, Check /opt/ directory for text file containing IP details for each student. Thanks
