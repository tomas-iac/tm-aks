
resource "azurerm_resource_group" "test" {
  name     = "test-rg"
  location = "northeurope"
}

resource "azurerm_virtual_network" "test" {
  name                = "test-vnet"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "test" {
  name                 = "test-subnet"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.0.0.0/20"]
}

// Example using remote module tag or branch
module "aks" {
  source = "github.com/tomas-iac/tm-aks//modules/tm-aks?ref=0.0.2"
  location = azurerm_resource_group.test.location
  resourceGroupName = azurerm_resource_group.test.name
  subnetId = azurerm_subnet.test.id
  vmSize = "Standard_B2s"
}