#!/bin/sh
# Pause briefly to ensure the system is ready
sleep 30

# Execute FortiNAC CLI commands to enable UI/SSH on port1
# (Adjust the command syntax as needed for your appliance)
echo "config system interface" | /usr/bin/fortinac-cli
echo "edit port1" | /usr/bin/fortinac-cli
echo "set allowaccess https-adminui ssh" | /usr/bin/fortinac-cli
echo "next" | /usr/bin/fortinac-cli
echo "end" | /usr/bin/fortinac-cli
