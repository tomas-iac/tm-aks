
resource "azurerm_resource_group" "test" {
  name     = "test-rg"
  location = "westeurope"
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

// Identity and RBAC
resource "azurerm_user_assigned_identity" "test" {
  name                = "aks-module-test-identity"
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_role_assignment" "test" {
  scope                = azurerm_resource_group.test.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.test.principal_id
}

// DNS zone
resource "azurerm_private_dns_zone" "privateendpoints" {
  name                = "privatelink.westeurope.azmk8s.io"
  resource_group_name = azurerm_resource_group.test.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "test" {
  name                  = "test"
  resource_group_name   = azurerm_resource_group.test.name
  private_dns_zone_name = azurerm_private_dns_zone.privateendpoints.name
  virtual_network_id    = azurerm_virtual_network.test.id
}

// Module testing (local reference)
module "aks" {
  source            = "../../terraform"
  name              = "aks-project1"
  location          = azurerm_resource_group.test.location
  resourceGroupName = azurerm_resource_group.test.name
  subnetId          = azurerm_subnet.test.id
  vmSize            = "Standard_B2s"
  identityId        = azurerm_user_assigned_identity.test.id
  identityClientId  = azurerm_user_assigned_identity.test.client_id
  identityObjectId  = azurerm_user_assigned_identity.test.principal_id
  outboundType      = "loadBalancer"
  privateCluster    = true
  privateDnsZoneId  = azurerm_private_dns_zone.privateendpoints.id
  depends_on        = [azurerm_role_assignment.test]
}

