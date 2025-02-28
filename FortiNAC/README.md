# FortiNAC Deployment on Azure

This repository contains Terraform configurations and supporting files to deploy **FortiNAC** on Azure in an automated and repeatable way.

## Repository Contents

- `deployment.json` – JSON configuration for deployment settings.
- `main.tf` – Main Terraform configuration file.
- `outputs.tf` – Terraform outputs to expose deployment results.
- `variables.tf` – Terraform variables to parameterize the deployment.
- `cloud-init.tpl` – Cloud-init template for initial VM configuration.
- `configure-fortinac.sh` – Script to automate FortiNAC configuration after deployment.

## Overview

This Terraform setup helps deploy FortiNAC in **Microsoft Azure**, automating the network and VM configuration. The deployment includes:

- **Standalone or High Availability (HA) FortiNAC** setup
- **Network interface configurations** for proper connectivity
- **Persistent storage attachment** for FortiNAC data
- **Post-installation configuration** using a script

## Prerequisites

Before deploying, ensure you have:

- [Terraform](https://www.terraform.io/downloads.html) installed
- An active **Azure subscription**
- **Azure CLI** installed and authenticated (`az login`)

## Deployment Steps

1. **Clone the Repository**

   ```bash
   git clone https://github.com/Interware-Systems-Inc/Fortinet.git
   cd Fortinet/fortinac/fortinac-azure-terraform
   ```

2. **Initialize Terraform**

   ```bash
   terraform init
   ```

3. **Validate the Configuration**

   ```bash
   terraform validate
   ```

4. **Plan the Deployment**

   ```bash
   terraform plan
   ```

5. **Apply the Deployment**

   ```bash
   terraform apply -auto-approve
   ```

6. **Access FortiNAC**

   - After deployment, get the assigned **public IP** using:
     ```bash
     terraform output fortinac_public_ip
     ```
   - Use **SSH or Azure Serial Console** to connect and configure.

## Troubleshooting

- If Terraform fails due to quota limits, request an **increase in Azure Compute quotas**.
- If FortiNAC does not detect the persistent disk, check Terraform storage attachment.

## Contribution

We welcome contributions! To contribute:

1. Fork the repository.
2. Create a new branch for your changes.
3. Submit a pull request for review.

## License

© Iman Kamyabizadeh, Interware Company. All rights reserved.

**Disclaimer:** This repository is intended for use in secure environments. Please review and test in a controlled setup before deploying in production.
