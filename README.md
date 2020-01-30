# terraform module for datadog slo dashboard

Assumes you are using aws.applicationelb (instead of elb)

To use this terraform module add the following to your terraform code:

```
module "slo_dashboard" {
  source  = "borgified/slo/datadog"
  version = "0.1.0"
  api_key = var.api_key
  app_key = var.app_key
  name = var.name
  filter_tags = var.filter_tags
  tags = var.tags
}
```

here's a minimal terraform.tfvars file (these values can also be specified in the various ways that terraform allows)

```
api_key = "abcdefg"
app_key = "zzzzxxxx"
name = "My Service Name"
filter_tags = "name:my-load-balancer,environment:production"
tags = [ "team:myteam", "service:myservice" ]
```
