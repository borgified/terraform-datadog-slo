variable "api_key" {
  description = "(Required) datadog api key"
  type        = "string"
}

variable "app_key" {
  description = "(Required) datadog app key"
  type        = "string"
}

variable "name" {
  description = "(Required) Name of Datadog service level objective."
  type        = "string"
}

variable "loadbalancer_type" {
  description = "if set to \"application\" will use aws.applicationelb.* metrics, otherwise will use aws.elb.* metrics"
  type        = "string"
}

variable "description" {
  description = "(Optional) A description of this service level objective."
  type        = "string"
  default     = "generated via Terraform"
}

variable "tags" {
  description = "(Optional) A list of tags to associate with your service level objective."
  type        = "list"
  default     = ["team:tbd"]
}

variable "thresholds" {
  description = "(Required) A map of thresholds and targets that define the service level objectives from the provided SLIs."
  type        = "map"
  default = {
    timeframe       = "30d"
    target          = 99.98
    warning         = 99.99
    target_display  = 99.980
    warning_display = 99.990
  }
}

variable "filter_tags" {
  description = "(Required) The list of tags to select specific metrics."
  type        = "string"
}

variable "monitor_ids" {
  description = "(Required for type = monitor) A list of numeric monitor IDs for which to use as SLIs. Their tags will be auto-imported into monitor_tags field in the API resource."
  type        = "list"
  default     = [1, 2, 3]
}

variable "groups" {
  description = "(Optional) A custom set of groups from the monitor(s) for which to use as the SLI instead of all the groups."
  type        = "list"
  default     = [1]
}
