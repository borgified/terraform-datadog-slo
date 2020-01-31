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
