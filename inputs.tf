variable "subnetId" {
  type = string
}

variable "resourceGroupName" {
  type = string
}
variable "location" {
  type = string
}

variable "vmSize" {
  type = string
  default = "Standard_B2s"
}
  