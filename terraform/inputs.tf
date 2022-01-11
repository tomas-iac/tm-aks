variable "subnetId" {
  type = string
}

variable "name" {
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

variable "identityId" {
  type = string
}

variable "identityClientId" {
  type = string
}

variable "identityObjectId" {
  type = string
}

variable "outboundType" {
  type = string
  default = "loadBalancer"
}
  