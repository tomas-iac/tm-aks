resource "azurerm_resource_group_template_deployment" "flux" {
  name                = "flux"
  resource_group_name = var.resourceGroupName
  deployment_mode     = "Incremental"
  template_content = <<TEMPLATE
{
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "resources": [
        {
            "type": "Microsoft.KubernetesConfiguration/fluxConfigurations",
            "apiVersion": "2022-03-01",
            "name": "infra",
            "dependsOn": [
                "flux"
            ],
            "properties": {
                "scope": "cluster",
                "namespace": "flux-system",
                "suspend": false,
                "configurationProtectedSettings": {},
                "sourceKind": "GitRepository",
                "kustomizations": {
                    "kustomization-1": {
                        "name": "infra",
                        "path": "clusters/${var.name}-aks",
                        "timeoutInSeconds": 180,
                        "syncIntervalInSeconds": 180,
                        "retryIntervalInSeconds": 180,
                        "force": true,
                        "prune": true,
                        "dependsOn": []
                    }
                },
                "gitRepository": {
                    "url": "https://github.com/tomas-iac/common-kubernetes",
                    "timeoutInSeconds": 180,
                    "syncIntervalInSeconds": 180,
                    "repositoryRef": {
                        "branch": "main"
                    },
                    "httpsUser": null,
                    "httpsCACert": null,
                    "sshKnownHosts": null,
                    "localAuthRef": null
                }
            },
            "scope": "Microsoft.ContainerService/managedClusters/aks-${var.name}"
        },
        {
            "type": "Microsoft.KubernetesConfiguration/extensions",
            "apiVersion": "2021-09-01",
            "name": "flux",
            "properties": {
                "extensionType": "microsoft.flux",
                "autoUpgradeMinorVersion": true
            },
            "scope": "Microsoft.ContainerService/managedClusters/aks-${var.name}"
        }
    ],
    "outputs": {}
}
TEMPLATE

    depends_on = [
      azurerm_kubernetes_cluster.aks
    ]

}