terraform {
  required_providers {
    fmc = {
      source = "CiscoDevNet/fmc"
      # version = "0.1.1"
    }
  }
}

### FMC Provider ###
provider "fmc" {
  # Configuration options
  fmc_username              = var.fmc_user
  fmc_password              = var.fmc_password
  fmc_host                  = var.fmc_server
  fmc_insecure_skip_verify  = true
}

locals {
  vm_group_a = {
      for vm in var.vm_group_a :
          vm.id => vm
  }
  vm_group_b = {
      for vm in var.vm_group_b :
          vm.id => vm
  }
}

### Build Host Objects per Server

resource "fmc_host_objects" "host-grp-a" {
  for_each = local.vm_group_a

  name = each.value.name
  value = each.value.clone.0.customize.0.network_interface.0.ipv4_address
  description = format("Host %s - Managed by Terraform", each.value.name)
}

resource "fmc_host_objects" "host-grp-b" {
  for_each = local.vm_group_b

  name = each.value.name
  value = each.value.clone.0.customize.0.network_interface.0.ipv4_address
  description = format("Host %s - Managed by Terraform", each.value.name)
}


resource "fmc_network_group_objects" "host-grp-a" {
  name          = "IST-HOST-GROUP-A"
  description   = "Host Server Group A - Terraform Managed"

  # dynamic "objects" {
  #   for_each = fmc_host_objects.host-grp-a
  #   content {
  #     id = objects.value["id"]
  #     type = objects.value["type"]
  #   }
  # }

  dynamic "literals" {
    for_each = fmc_host_objects.host-grp-a
    content {
      value = literals.value["value"]
      type = literals.value["type"]
    }
  }


}

resource "fmc_network_group_objects" "host-grp-b" {
  name          = "IST-HOST-GROUP-B"
  description   = "Host Server Group B - Terraform Managed"

  # dynamic "objects" {
  #   for_each = fmc_host_objects.host-grp-b
  #   content {
  #     id = objects.value["id"]
  #     type = objects.value["type"]
  #   }
  # }

  dynamic "literals" {
    for_each = fmc_host_objects.host-grp-b
    content {
      value = literals.value["value"]
      type = literals.value["type"]
    }
  }

}
