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
data "terraform_remote_state" "vc-mod" {
  backend = "remote"

  config = {
    organization = "mel-ciscolabs-com"
    workspaces = {
      name = "ist-dcn-vcenter"
    }
  }
}

## Firewpower Management Center (FMC) Module
module "fmc" {
  source = "./modules/fmc"

  fmc_user      = var.fmc_user
  fmc_password  = var.fmc_password
  fmc_server    = var.fmc_server
  vm_group_a    = try(data.terraform_remote_state.vc-mod.outputs.vm_group_a, {})
  vm_group_b    = try(data.terraform_remote_state.vc-mod.outputs.vm_group_b, {})

}
