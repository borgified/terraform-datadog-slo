variable "api_key" {
  description = "(Required) datadog api key"
  type        = string
}

variable "app_key" {
  description = "(Required) datadog app key"
  type        = string
}

variable "name" {
  description = "(Required) Name of Datadog service level objective."
  type        = string
}

variable "loadbalancer_type" {
  description = "if set to \"application\" will use aws.applicationelb.* metrics, otherwise will use aws.elb.* metrics"
  type        = string
}

variable "description" {
  description = "(Optional) A description of this service level objective."
  type        = string
  default     = "generated via Terraform"
}

variable "tags" {
  description = "(Optional) A list of tags to associate with your service level objective."
  type        = list
  default     = ["team:tbd"]
}

variable "filter_tags" {
  description = "(Required) Tags to select specific metrics."
  type        = string
}
