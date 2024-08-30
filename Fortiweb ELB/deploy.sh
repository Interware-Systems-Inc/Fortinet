#!/bin/bash

# Define variables
resourceGroupName="FortiHoL"
deploymentName="FortiWebDeployment"
templateFilePath="./template.json"
parametersFilePath="./parameters.json"
location="canadacentral"

# Accept Azure Marketplace legal terms for the Fortinet FortiWeb image
echo "Accepting Azure Marketplace legal terms for Fortinet FortiWeb..."
az vm image terms accept --publisher fortinet --offer fortinet_fortiweb-vm_v5 --plan fortinet_fw-vm

if [ $? -eq 0 ]; then
    echo "Legal terms accepted successfully."
else
    echo "Failed to accept legal terms. Please check the error messages above."
    exit 1
fi

# Create Resource Group if it doesn't exist
echo "Checking if resource group '$resourceGroupName' exists..."
if ! az group exists --name "$resourceGroupName"; then
    echo "Resource group '$resourceGroupName' does not exist. Creating..."
    az group create --name "$resourceGroupName" --location "$location"
else
    echo "Resource group '$resourceGroupName' already exists."
fi

# Deploy the ARM template
echo "Starting deployment..."
az deployment group create \
  --name "$deploymentName" \
  --resource-group "$resourceGroupName" \
  --template-file "$templateFilePath" \
  --parameters @"$parametersFilePath"

if [ $? -eq 0 ]; then
    echo "Deployment succeeded!"
else
    echo "Deployment failed. Please check the error messages above."
fi
