##############################
# Datadog Private Location  #
##############################

# Note: The Datadog Terraform provider does not expose a stable resource for creating
# synthetics private locations across all versions. Creating the Private Location
# object in Datadog (to obtain the worker configuration JSON) should be done via:
#  - Datadog UI: Synthetics → Private Locations → Create → Download configuration
#  - or the Datadog API (scripted).
# The Helm chart below requires the configuration JSON file (synthetics-check-runner.json)
# to be present; see ../README.md for the workflow.

##################################
# Kubernetes / Helm deployment  #
##################################

locals {
  # sanitized name derived from the Datadog Private Location name
  sanitized_private_location_name = lower(regexreplace(var.private_location_name, "[^a-zA-Z0-9]+", "-"))
  # allow explicit var.namespace to override; otherwise use sanitized private location name
  namespace_from_private_location  = var.namespace != "" ? var.namespace : local.sanitized_private_location_name
  # helm release name derived from the private location name
  release_base_name = "${local.sanitized_private_location_name}-synthetics-private-location"
}

resource "kubernetes_namespace" "synthetics" {
  metadata {
    name = local.namespace_from_private_location
  }
}

resource "helm_release" "synthetics_private_location" {
  name       = local.release_base_name
  repository = "https://helm.datadoghq.com"
  chart      = "synthetics-private-location"
  namespace  = kubernetes_namespace.synthetics.metadata[0].name
  version    = "0.17.20"

  # The chart expects the private location worker configuration JSON.
  # Provide it via a chart value. Helm provider v3+ expects 'set' as a list attribute.
  set = [{
    name  = "configFile"
    value = try(file(var.synthetics_config_file), "{}")
  }]

  # Wait for resources to be ready before marking the release as successful
  timeout = 600
}

