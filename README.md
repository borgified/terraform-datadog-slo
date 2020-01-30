# terraform module for datadog slo dashboard

To use this terraform module add the following to your terraform code:

```
module "slo_dashboard" {
  source  = "borgified/slo/datadog"
  version = "0.1.0"
  api_key = "xxxxxxxxxxxxxx"
  app_key = "xxxxxxxxxxxxxx"
  loadbalancer_type = "application"
  name = "my service name"
  filter_tags = "name:my-load-balancer,environment:production"
  tags = [ "team:myteam", "service:myservice" ]
}
```
