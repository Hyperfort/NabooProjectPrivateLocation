This folder contains Terraform configuration to:

- (Optionally) create a Datadog Synthetics Private Location named "Naboo Project - NonProd"
- deploy the Datadog Synthetics Private Location worker to a Kubernetes cluster using the official Helm chart

Quick notes:

1. Run `terraform init`.
2. To create the Datadog Private Location object in Datadog (best-effort), ensure `datadog_api_key` and `datadog_app_key` are set (via variables or env vars) and keep `create_datadog_private_location = true` (default). Run `terraform apply` to create the resource.
3. Retrieve the Private Location configuration JSON from Datadog (Synthetics → Private Locations → the new location → Download configuration) and save it to `config/synthetics-check-runner.json` (or set `synthetics_config_file` variable to a different path).
4. Re-run `terraform apply` to deploy the Helm chart which reads the config file and starts the worker.

Adjust `variables.tf` values as needed for your environment (kubeconfig path, namespace, datadog site).

