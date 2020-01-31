# terraform module for datadog slo dashboard

To use this terraform module add the following to your terraform code:

```
module "slo_dashboard" {
  source  = "borgified/slo/datadog"
  version = "0.3.0"
  api_key = "xxxxxxxxxxxxxx"
  app_key = "xxxxxxxxxxxxxx"
  loadbalancer_type = "application"
  name = "my service name"
  filter_tags = "name:my-load-balancer,environment:production"
  tags = [ "team:myteam", "service:myservice" ]
}
```

If you want direct links to the dashboards/monitors add the following:

```
output "availability_url" {
  description = "availability slo"
  value       = "https://app.datadoghq.com/slo?slo_id=${datadog_service_level_objective.availability.id}"
}

output "latency_url" {
  description = "latency slo"
  value       = "https://app.datadoghq.com/slo?slo_id=${datadog_service_level_objective.latency.id}"
}

output "slo_dashboard_url" {
  description = "slo dashboard"
  value       = "https://app.datadoghq.com/dashboard/${datadog_dashboard.slo.id}"
}
```
