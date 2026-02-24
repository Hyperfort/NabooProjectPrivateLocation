variable "datadog_api_key" {
  description = "Datadog API key (can also be provided via DD_API_KEY env var)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "datadog_app_key" {
  description = "Datadog APP key (can also be provided via DD_APP_KEY env var)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "datadog_site" {
  description = "Datadog site (eg. datadoghq.com, datadoghq.eu). Leave empty for default"
  type        = string
  default     = "datadoghq.com"
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file used by the Kubernetes/Helm providers"
  type        = string
  default     = "/home/melizondo/.kube/config"
}

variable "namespace" {
  description = "Kubernetes namespace to install the private location worker into (sanitized from private_location_name)"
  type        = string
  default     = "naboo-project-nonprod"
}

variable "private_location_name" {
  description = "Name for the Datadog Private Location"
  type        = string
  default     = "Naboo Project - NonProd"
}

variable "create_datadog_private_location" {
  description = "If true, create the Datadog private location resource. If false, assume you will supply an existing config file."
  type        = bool
  default     = true
}

variable "synthetics_config_file" {
  description = "Path to a local JSON config file for the private location worker (used when create_datadog_private_location = false)."
  type        = string
  default     = "config/synthetics-check-runner.json"
}

