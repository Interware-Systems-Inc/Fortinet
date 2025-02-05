#!/bin/bash
#author:iman kamyabizadeh
# Define your variables
RESOURCE_GROUP="FortiHoL"  # Ensure this matches the resource group in your parameters.json
LOCATION="canadacentral"          # Ensure this matches the location in your parameters.json
TEMPLATE_FILE="./template.json"
PARAMETERS_FILE="./parameters.json"
DEPLOYMENT_NAME="fortianalyzer-deployment"
PUBLISHER="fortinet"
OFFER="fortinet-fortianalyzer"
PLAN="fortinet-fortianalyzer"

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

# Accept Marketplace Terms for FortiAnalyzer
echo "Accepting Marketplace terms for FortiAnalyzer..."
TERMS_ACCEPTED=$(az vm image terms show --publisher $PUBLISHER --offer $OFFER --plan $PLAN --query 'accepted' -o tsv)

if [ "$TERMS_ACCEPTED" != "true" ]; then
    az vm image terms accept --publisher $PUBLISHER --offer $OFFER --plan $PLAN
    echo "Marketplace terms accepted."
else
    echo "Marketplace terms were already accepted."
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
