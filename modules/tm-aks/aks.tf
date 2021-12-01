resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks"
  location            = var.location
  resource_group_name = var.resourceGroupName
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = var.vmSize
  }

  identity {
    type = "SystemAssigned"
  }

}
