resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.name}"
  location            = var.location
  resource_group_name = var.resourceGroupName
  dns_prefix          = "aks-${var.name}"

  default_node_pool {
    name           = "default"
    node_count     = var.nodeCount
    vm_size        = var.vmSize
    vnet_subnet_id = var.subnetId
    max_pods       = 70
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
    type = "UserAssigned"
    identity_ids = [
      var.identityId
    ]
  }

  kubelet_identity {
    user_assigned_identity_id = var.identityId
    client_id                 = var.identityClientId
    object_id                 = var.identityObjectId
  }

  azure_policy_enabled = true

  key_vault_secrets_provider {
    secret_rotation_enabled  = false
    secret_rotation_interval = "2m"
  }

  dynamic "oms_agent" {
    for_each = (var.enableMonitoring ? [1] : [])
    content {
      log_analytics_workspace_id = var.logAnalyticsWorkspaceId
    }
  }

  role_based_access_control_enabled = true

  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    managed            = true
  }

}

// API server logging
resource "azurerm_monitor_diagnostic_setting" "aks" {
  count                      = var.enableAudit ? 1 : 0
  name                       = "akslogs"
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = var.logAnalyticsWorkspaceId

  log {
    category = "kube-audit"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "kube-audit-admin"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  lifecycle {
    ignore_changes = [log, metric]
  }
}
