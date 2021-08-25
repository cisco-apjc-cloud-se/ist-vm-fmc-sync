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

variable "dc_networks" {
}

variable "vm_group_a" {
  type = object({
    group_size = number
    name = string
    host_name = string
    num_cpus = number
    memory = number
    network_id = string  ## TBC
    domain = string
    dns_list = list(string) ##["64.104.123.245","171.70.168.183"]
  })
}

variable "vm_group_b" {
  type = object({
    group_size = number
    name = string
    host_name = string
    num_cpus = number
    memory = number
    network_id = string  ## TBC
    domain = string
    dns_list = list(string) ##["64.104.123.245","171.70.168.183"]
  })
}
