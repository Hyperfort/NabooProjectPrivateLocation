##############################
# Datadog Private Location   #
##############################

# Create/manage the private location in Datadog via Terraform provider.

resource "datadog_synthetics_private_location" "pl" {
  count = var.create_datadog_private_location ? 1 : 0

  name        = var.private_location_name
  description = "Synthetics Private Location Managed By Terraform"
  tags        = ["env:non-prod"]
}

##################################
# Kubernetes / Helm deployment   #
##################################

locals {
  sanitized_private_location_name = "naboo-project-nonprod"
  namespace_from_private_location = var.namespace != "" ? var.namespace : local.sanitized_private_location_name
  release_base_name               = "${local.sanitized_private_location_name}-synthetics-private-location"
  synthetics_config_path          = "${path.module}/${var.synthetics_config_file}"

  # Use generated config when creating the private location; otherwise fall back to local file.
  # The Helm chart expects a JSON string via "configFile". [2](https://github.com/DataDog/helm-charts/blob/main/charts/synthetics-private-location/README.md)
  private_location_config = var.create_datadog_private_location ? datadog_synthetics_private_location.pl[0].config : try(file(local.synthetics_config_path), "{}")
}

resource "kubernetes_namespace_v1" "synthetics" {
  metadata {
    name = local.namespace_from_private_location
  }
}

resource "helm_release" "synthetics_private_location" {
  provider   = helm
  name       = local.release_base_name
  repository = "https://helm.datadoghq.com"
  chart      = "synthetics-private-location"
  namespace  = kubernetes_namespace_v1.synthetics.metadata[0].name
  version    = "0.17.20"

  values = [
    yamlencode({
      configFile = local.private_location_config
    })
  ]

  timeout = 600
}
