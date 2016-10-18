#!/bin/bash
###This will deploy the required infrastructure on Azure##########

### Install JQ - a command line JSON processor to edit the parameter file####
 wget http://stedolan.github.io/jq/download/linux64/jq 
 chmod +x ./jq
 cp jq /usr/bin
 

 
### Login to Azure Subscription interactively ####

az login


######List Azure Roles########


echo "You can get the Azure Role names available below this..."

az role list -o json | jq '.[] | {"roleName":.properties.roleName, "description":.properties.description}'


###Non-Fixed Parameter#####


echo "Please enter the User Role "
read password

echo "Please enter email id of the user to assign the role"
read emailid

echo "Please enter the User Role "
read userrole

echo "Please enter resource group to provide access to this alone"
read resourcegroup



if [ -z "$resourcegroup" ]; then
	az role assignment create --assignee $emailid --role $userrole -g $resourcegroup
else 
	az role assignment create --assignee $emailid --role $userrole
fi
