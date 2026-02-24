terraform {
  required_version = ">= 1.0"
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_site != "" ? "https://api.${var.datadog_site}" : null
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

/* If you need to explicitly configure the Helm provider to point to a kubeconfig,
   add a provider "helm" block here. Leaving it out will make the provider rely on
   the environment (KUBECONFIG) or in-cluster config. */

provider "helm" {}


