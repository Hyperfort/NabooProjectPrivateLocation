output "datadog_private_location_id" {
  description = "ID of the Datadog private location (if created)"
  value       = try(one(datadog_synthetics_private_location.pl[*].id), "")
}

output "datadog_private_location_config" {
  description = "Sensitive config used by the worker (if created)"
  value       = try(one(datadog_synthetics_private_location.pl[*].config), "")
  sensitive   = true
}

output "helm_release_name" {
  description = "Name of the Helm release deployed for the private location worker"
  value       = helm_release.synthetics_private_location.name
}
