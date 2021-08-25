terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "mel-ciscolabs-com"
    workspaces {
      name = "ist-vm-fmc-sync"
    }
  }
}

### Remote Shared State ###
data "terraform_remote_state" "vc-outputs" {
  backend = "remote"

  config = {
    organization = "mel-ciscolabs-com"
    workspaces = {
      name = "ist-challenge-dcn"
    }
  }
}

output "test "{
  value = data.terraform_remote_state.vc-outputs
}

### Nested Modules ###

# ## VMware vCenter Module
# module "vcenter" {
#   source = "./modules/vcenter"
#
#   vcenter_user        = var.vcenter_user
#   vcenter_password    = var.vcenter_password
#   vcenter_server      = var.vcenter_server
#   vcenter_dc          = var.vcenter_dc
#   vcenter_cluster     = var.vcenter_cluster
#   vcenter_datastore   = var.vcenter_datastore
#   vcenter_vmtemplate  = var.vcenter_vmtemplate
#   vcenter_dvs         = var.vcenter_dvs
#
#   # dc_networks         = module.dcnm.dc_networks
#   # vm_group_a          = var.vm_group_a
#   # vm_group_b          = var.vm_group_b
#
#   # depends_on = [module.dcnm]
# }

# ## Firewpower Management Center (FMC) Module
# module "fmc" {
#   source = "./modules/fmc"
#
#   fmc_user      = var.fmc_user
#   fmc_password  = var.fmc_password
#   fmc_server    = var.fmc_server
#   vm_group_a    = data.terraform_remote_state.vc-outputs.vm_group_a
#   vm_group_b    = data.terraform_remote_state.vc-outputs.vm_group_b
#
#   # depends_on = [module.vcenter]
#
# }
