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
      # serial_number = string
      # vlan_id = number
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
    # attachments = map(object({
    #   name = string
    #   serial_number = string
    #   # vlan_id = number
    #   attach = bool
    #   switch_ports = list(string)
    # }))
  }))
}
