### DCNM Variables

variable "dcnm_user" {
  type = string
}

variable "dcnm_password" {
  type = string
}

variable "dcnm_url" {
  type = string
}

variable "dc_fabric" {
  type = string
}

variable "dc_switches" {
  type = map(list(string))
}

variable "svr_cluster" {
  type = map(object({
      name = string
      attach = bool
      switch_ports = list(string)
    }))
}

variable "dc_vrf" {
  type = string
}

variable "dc_networks" {
  type = map(object({
    name = string
    description = string
    ip_subnet = string
    vni_id = number
    vlan_id = number
    deploy = bool
  }))
}

### vCenter Variables

variable "vcenter_user" {
  type = string
}

variable "vcenter_password" {
  type = string
}

variable "vcenter_server" {
  type = string
}

variable "vcenter_dc" {
  type = string
}

variable "vcenter_cluster" {
  type = string
}

variable "vcenter_datastore" {
  type = string
}

variable "vcenter_vmtemplate" {
  type = string
}

variable "vcenter_dvs" {
  type = string
}

variable "vm_group_a" {
  type = object({
    group_size = number
    name = string
    host_name = string
    num_cpus = number
    memory = number
    network_id = string
    domain = string
    dns_list = list(string)
  })
}

variable "vm_group_b" {
  type = object({
    group_size = number
    name = string
    host_name = string
    num_cpus = number
    memory = number
    network_id = string
    domain = string
    dns_list = list(string)
  })
}

### FMC Variables

variable "fmc_user" {
  type = string
}

variable "fmc_password" {
  type = string
}

variable "fmc_server" {
  type = string
}
