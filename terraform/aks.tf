resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.name}"
  location            = var.location
  resource_group_name = var.resourceGroupName
  dns_prefix          = "aks-${var.name}"

  default_node_pool {
    name           = "default"
    node_count     = 2
    vm_size        = var.vmSize
    vnet_subnet_id = var.subnetId
  }

  private_cluster_enabled = var.privateCluster
  private_dns_zone_id     = var.privateDnsZoneId

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "172.20.0.0/22"
    dns_service_ip     = "172.20.0.10"
    docker_bridge_cidr = "172.24.0.0/24"
    outbound_type      = var.outboundType
  }

  identity {
    type                      = "UserAssigned"
    user_assigned_identity_id = var.identityId
  }

  kubelet_identity {
    user_assigned_identity_id = var.identityId
    client_id                 = var.identityClientId
    object_id                 = var.identityObjectId
  }

}
