#!/bin/bash

# Enable Boot Diagnostics
az vm boot-diagnostics enable \
  --resource-group FortiHoL \
  --name interware \
  --storage-account fortinacdiagstorage

# Wait for FortiNAC to boot
sleep 60

# Log into FortiNAC CLI and configure access
(
echo "admin"
sleep 2
echo ""
sleep 2
echo "config system interface"
sleep 2
echo "edit port1"
sleep 2
echo "set allowaccess https-adminui ssh"
sleep 2
echo "next"
sleep 2
echo "end"
sleep 2
) | ssh -o StrictHostKeyChecking=no admin@$(az network public-ip show -g FortiHoL -n interware-ip --query ipAddress -o tsv)

echo "FortiNAC Pre-Configuration Completed!"
