# Integrated DC Network, Infrastructure & Security Automation - Part 2

[![published](https://static.production.devnetcloud.com/codeexchange/assets/images/devnet-published.svg)](https://developer.cisco.com/codeexchange/github/repo/cisco-apjc-cloud-se/ist-vcenter-dcnm)

## Overview
This repository is intended for use as 2nd, linked Terraform workspace.  The 1st primary workspace (using the ist-dcn-vcenter GitHub repository) will share its output state to this workspace and be configured to trigger this workspace to run.

The output of the 1st workspace includes two group objects, one for each group of managed VMs.  This Terraform plan will use these group details to generate host objects and network group objects dynamically.

## Requirements
**Note:** This workspace expects to be triggered from another workspace using the "ist-dcn-vcenter" GitHub repository.  That workspace must be configured first and then configured to share its state with this workspace as well as trigger this workspace to run.

The Infrastructure-as-Code environment will require the following:
* GitHub Repository for Terraform plans, modules and variables as JSON files
* Terraform Cloud for Business account with a workspace associated to the GitHub repository above
* Cisco Intersight (SaaS) platform account with sufficient Advantage licensing
* An Intersight Assist appliance VM connected to the Intersight account above

This example will then use the following on-premise domain managers. These will need to be fully commissioned and a suitable user account provided for Terraform to use for provisioning.
* Cisco Data Center Network Manager (DCNM)
* VMware vCenter
* Cisco Firepower Management Center (FMC)

![Overview Image](/images/overview.png)

The Firepower (FMC) module makes the following assumptions:
* An existing FMC server instance has been deployed
* The FMC server is accessible by HTTPS from the Intersight Assist VM.
* The following variables are defined within the Terraform Workspace.  These variables should not be configured within the public GitHub repository files.
  * FMC account username (fmc_user)
  * FMC account password (fmc_password)
  * FMC server IP/FQDN (fmc_server)

**Note:** The FMC security automation component has been moved to a 2nd GitHub repository and will now be run from a 2nd, linked Terraform workspace.

## Link to Github Repositories
https://github.com/cisco-apjc-cloud-se/ist-dcn-vcenter
https://github.com/cisco-apjc-cloud-se/ist-vm-fmc-sync


## Steps to Deploy Use Case
1.	Complete the setup for the primary "ist-dcn-vcenter" workspace.  This includes setting up Intersight Service for Terraform (IST).
2.	In Terraform Cloud for Business, create a new Terraform Workspace and associate to this GitHub repository.

![TFCB Agent Image](/images/tfcb-workspace.png)

3.	In Terraform Cloud for Business, configure the workspace to the use the Terraform Agent pool configured from Intersight.

![TFCB Agent Image](/images/tfcb-agent.png)

4.	In Terraform Cloud for Business, configure the necessary user account variables for the FMC servers.

![TFCB Variables Image](/images/tfcb-vars.png)

5.  In Terraform Cloud for Business, under Settings, configure this workspace to be triggered by the primary "ist-dcn-vcenter" workspace.  

![TFCB Run Trigger Image](/images/tfcb-trigger.png)

6.  In Terraform Cloud for Business, in the 1st workspace (ist-dcn-vcenter) under Settings, configure this workspace to share its state file with this new workspace (ist-vm-fmc-sync).  

![TFCB Share State Image](/images/tfcb-share.png)


## Execute Deployment
Any successful runs in the primary "ist-dcn-vcenter" workspace will trigger this workspace to run.  Any future changes to pushed to thist GitHub repository or the primary workspace repository will automatically trigger a new plan deployment.

## Results
If successfully executed, the Terraform plan will result in the following configuration for each domain manager.

### FMC Module
* New host type network objects for each VM defined the vCenter module.
  * Each VM’s name and static IP address will be used to define the host object.

![FMC host](/images/fmc-host.png)

* New network group objects for each group of VM servers
  * The IP addresses from the host objects above will be grouped into a single object.  It is expected this object will be used for any firewall rule definitions.

  **Note:** The FMC provider has an issue removing objects from network groups.  As a workaround, the IP addresses of the host objects will be used instead as literal objects in the group.

![FMC group](/images/fmc-group.png)
