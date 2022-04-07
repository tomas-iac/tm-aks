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
  type    = string
  default = "Standard_B4ms"
}

variable "nodeCount" {
  type    = string
  default = 3
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
  type    = string
  default = "loadBalancer"
}

variable "privateDnsZoneId" {
  type    = string
  default = null
}

variable "privateCluster" {
  type    = bool
  default = false
}
  
variable "logAnalyticsWorkspaceId" {
  type    = string
  default = null
}

variable "enableMonitoring" {
  type    = bool
  default = false
}

variable "enableAudit" {
  type    = bool
  default = false
}
