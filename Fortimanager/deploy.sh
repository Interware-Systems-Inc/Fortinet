#!/bin/bash
#author:iman kamyabizadeh
# Define your variables
RESOURCE_GROUP="FortiHoL"  # Change to your desired resource group
LOCATION="canadacentral"   # Set the Azure region where you want to deploy
TEMPLATE_FILE="./template.json"
PARAMETERS_FILE="./parameters.json"
DEPLOYMENT_NAME="fortimanager-deployment"

# Check if the Azure CLI is installed
if ! command -v az &> /dev/null
then
    echo "Azure CLI not found, please install it first."
    exit
fi

# Log in to Azure if not already logged in
if ! az account show &> /dev/null
then
    echo "Logging in to Azure..."
    az login
fi

# Create the resource group if it doesn't exist
echo "Creating Resource Group if it doesn't exist..."
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

# Deploy the ARM template with parameters
echo "Starting deployment..."
az deployment group create \
    --name "$DEPLOYMENT_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --template-file "$TEMPLATE_FILE" \
    --parameters @"$PARAMETERS_FILE"

# Check the deployment status
if [ $? -eq 0 ]; then
    echo "Deployment succeeded!"
else
    echo "Deployment failed."
fi
