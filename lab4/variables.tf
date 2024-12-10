variable "RG_NAME" {
  type    = string
  default = "RG4"
}

variable "LOCATION" {
  type    = string
  default = "westeurope"
}

variable "VM_SIZE" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "APP_GW_SKU" {
  type    = string
  default = "Standard_v2"
}

variable "APP_GW_CAPACITY" {
  type    = number
  default = 2
}