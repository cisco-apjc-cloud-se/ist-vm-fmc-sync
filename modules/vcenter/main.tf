terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      # version = "1.24.2"
    }
  }
}

### vSphere ESXi Provider
provider "vsphere" {
  user           = var.vcenter_user
  password       = var.vcenter_password
  vsphere_server = var.vcenter_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

### Existing Data Sources
data "vsphere_datacenter" "dc" {
  name          = var.vcenter_dc
}

data "vsphere_compute_cluster" "svr_cluster" {
  name          = var.vcenter_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

# data "vsphere_datastore" "ds" {
#   name          = var.vcenter_datastore
#   datacenter_id = data.vsphere_datacenter.dc.id
# }

data "vsphere_virtual_machine" "template" {
  name          = var.vcenter_vmtemplate
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_distributed_virtual_switch" "dvs" {
  name          = var.vcenter_dvs
  datacenter_id = data.vsphere_datacenter.dc.id
}

# ### Build New Distribute Port Group(s)
# resource "vsphere_distributed_port_group" "dpg" {
#   for_each                        = var.dc_networks
#
#   name                            = each.value.name
#   distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.dvs.id
#   vlan_id                         = each.value.vlan_id
# }

### Build VM Server Group A
resource "vsphere_virtual_machine" "grp-a" {
  count               = var.vm_group_a.group_size

  name                = format("%s-%d", var.vm_group_a.name, (count.index + 1))
  resource_pool_id    = data.vsphere_compute_cluster.svr_cluster.resource_pool_id
  datastore_id        = data.vsphere_datastore.ds.id

  num_cpus            = var.vm_group_a.num_cpus  # 2
  memory              = var.vm_group_a.memory
  guest_id            = data.vsphere_virtual_machine.template.guest_id
  scsi_type           = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id        = vsphere_distributed_port_group.dpg[var.vm_group_a.network_id].id
    adapter_type      = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label             = "disk0"
    size              = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub     = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned  = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid     = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name     = format("%s-%d", var.vm_group_a.host_name, (count.index + 1))
        domain        = var.vm_group_a.domain
      }

      network_interface {
        ipv4_address  = cidrhost(var.dc_networks[var.vm_group_a.network_id].ipv4_gateway, (count.index + 2))
        ipv4_netmask  = regex("\\/(\\d{1,2})$",var.dc_networks[var.vm_group_a.network_id].ipv4_gateway)[0]
      }
      ipv4_gateway    = regex("\\d{1,3}.\\d{1,3}.\\d{1,3}.\\d{1,3}",var.dc_networks[var.vm_group_a.network_id].ipv4_gateway)
      dns_server_list = var.vm_group_a.dns_list #["64.104.123.245","171.70.168.183"]
    }
  }
}

### Build VM Server Group B
resource "vsphere_virtual_machine" "grp-b" {
  count               = var.vm_group_b.group_size

  name                = format("%s-%d", var.vm_group_b.name, (count.index + 1))
  resource_pool_id    = data.vsphere_compute_cluster.svr_cluster.resource_pool_id
  datastore_id        = data.vsphere_datastore.ds.id

  num_cpus            = var.vm_group_b.num_cpus  # 2
  memory              = var.vm_group_b.memory
  guest_id            = data.vsphere_virtual_machine.template.guest_id
  scsi_type           = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    # network_id        = each.network_id #data.vsphere_network.aciNetworkEpg1.id
    network_id        = vsphere_distributed_port_group.dpg[var.vm_group_b.network_id].id
    adapter_type      = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label             = "disk0"
    size              = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub     = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned  = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid     = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name     = format("%s-%d", var.vm_group_b.host_name, (count.index + 1))
        domain        = var.vm_group_b.domain
      }

      network_interface {
        ipv4_address  = cidrhost(var.dc_networks[var.vm_group_b.network_id].ipv4_gateway, (count.index + 2))
        ipv4_netmask  = regex("\\/(\\d{1,2})$",var.dc_networks[var.vm_group_b.network_id].ipv4_gateway)[0]
      }
      ipv4_gateway    = regex("\\d{1,3}.\\d{1,3}.\\d{1,3}.\\d{1,3}",var.dc_networks[var.vm_group_b.network_id].ipv4_gateway)
      dns_server_list = var.vm_group_b.dns_list #["64.104.123.245","171.70.168.183"]
    }
  }
}
