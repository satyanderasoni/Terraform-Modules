variable "rgs" {
  description = "Map of resource groups with their properties"
  type = map(object({
    rg_name  = string
    location = string
    tags     = map(string)
  }))
}
