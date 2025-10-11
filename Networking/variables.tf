variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}

variable "vnets" {
  description = "values for vnet"
  type = map(object({
    name          = string
    address_space = list(string)
  }))
}

variable "subnets" {
  description = "values for subnet"
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
}

variable "nics" {
  description = "values for nic"
  type = map(object({
    name      = string
    subnet_id = string
  }))
}
