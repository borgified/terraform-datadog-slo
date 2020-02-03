locals {

  applicationelb_numerator = "sum:aws.applicationelb.httpcode_elb_4xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_target_4xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_target_3xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_target_2xx{${var.filter_tags}}.as_count()"

  applicationelb_denominator = "sum:aws.applicationelb.httpcode_elb_4xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_target_4xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_target_3xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_target_2xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_elb_5xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_target_5xx{${var.filter_tags}}.as_count()"

  elb_numerator = "sum:aws.elb.httpcode_elb_4xx{${var.filter_tags}}.as_count()+sum:aws.elb.httpcode_backend_4xx{${var.filter_tags}}.as_count()+sum:aws.elb.httpcode_backend_3xx{${var.filter_tags}}.as_count()+sum:aws.elb.httpcode_backend_2xx{${var.filter_tags}}.as_count()"

  elb_denominator = "sum:aws.elb.httpcode_elb_4xx{${var.filter_tags}}.as_count()+sum:aws.elb.httpcode_backend_4xx{${var.filter_tags}}.as_count()+sum:aws.elb.httpcode_backend_3xx{${var.filter_tags}}.as_count()+sum:aws.elb.httpcode_backend_2xx{${var.filter_tags}}.as_count()+sum:aws.elb.httpcode_elb_5xx{${var.filter_tags}}.as_count()+sum:aws.elb.httpcode_backend_5xx{${var.filter_tags}}.as_count()"

}

# Create a new Datadog service level objective
resource "datadog_service_level_objective" "availability" {
  name        = "Availability SLO for ${var.name}"
  type        = "metric"
  description = var.description
  query {
    numerator   = var.loadbalancer_type == "application" ? local.applicationelb_numerator : local.elb_numerator
    denominator = var.loadbalancer_type == "application" ? local.applicationelb_denominator : local.elb_denominator
  }

  thresholds {
    timeframe = "30d"
    target    = "99"
    warning   = "99.9"
  }

  tags = concat(["slo:availability"], var.tags)
}

# Create a new Datadog monitor
resource "datadog_monitor" "latency" {
  name    = "Latency Monitor for ${var.name}"
  type    = "metric alert"
  message = "Latency Monitor for ${var.name}"

  query = "max(last_1h):max:aws.applicationelb.target_response_time.p95{${var.filter_tags}} > 0.05"

  thresholds = {
    critical = "0.05"
  }

  require_full_window = true
  notify_no_data      = false

  timeout_h         = 60
  include_tags      = true
  no_data_timeframe = 0
  evaluation_delay  = 900

  tags = var.tags
}

resource "datadog_monitor" "availability" {
  name    = "Availability Monitor for ${var.name}"
  type    = "metric alert"
  message = "Availability Monitor for ${var.name}"

  query = "max(last_1h):(sum:aws.applicationelb.httpcode_elb_4xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_target_4xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_target_3xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_target_2xx{${var.filter_tags}}.as_count()) / (sum:aws.applicationelb.httpcode_elb_4xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_target_4xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_target_3xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_target_2xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_elb_5xx{${var.filter_tags}}.as_count()+sum:aws.applicationelb.httpcode_target_5xx{${var.filter_tags}}.as_count()) < .99"

  require_full_window = true
  notify_no_data      = false

  timeout_h         = 60
  include_tags      = true
  no_data_timeframe = 0
  evaluation_delay  = 900

  tags = var.tags
}

# Create a new Datadog service level objective
resource "datadog_service_level_objective" "latency" {
  name        = "Latency SLO for ${var.name}"
  type        = "monitor"
  description = var.description
  monitor_ids = [datadog_monitor.latency.id]

  thresholds {
    timeframe = "30d"
    target    = "99"
    warning   = "99.9"
  }

  tags = concat(["slo:latency"], var.tags)
}

# slo dashboard
resource "datadog_dashboard" "slo" {
  title        = "SLO Dashboard for ${var.name}"
  description  = "Created using the Datadog provider in Terraform"
  layout_type  = "ordered"
  is_read_only = true

  widget {
    query_value_definition {
      request {
        q          = "((avg:aws.applicationelb.httpcode_elb_4xx{${var.filter_tags}}.as_rate()+avg:aws.applicationelb.httpcode_target_2xx{${var.filter_tags}}.as_rate()+avg:aws.applicationelb.httpcode_target_3xx{${var.filter_tags}}.as_rate()+avg:aws.applicationelb.httpcode_target_4xx{${var.filter_tags}}.as_rate())/(avg:aws.applicationelb.httpcode_elb_4xx{${var.filter_tags}}.as_rate()+avg:aws.applicationelb.httpcode_target_2xx{${var.filter_tags}}.as_rate()+avg:aws.applicationelb.httpcode_target_3xx{${var.filter_tags}}.as_rate()+avg:aws.applicationelb.httpcode_target_4xx{${var.filter_tags}}.as_rate()+avg:aws.applicationelb.httpcode_elb_5xx{${var.filter_tags}}.as_rate()+avg:aws.applicationelb.httpcode_target_5xx{${var.filter_tags}}.as_rate()))*100"
        aggregator = "last"
        conditional_formats {
          comparator = "<"
          value      = "99.00"
          palette    = "white_on_red"
        }
        conditional_formats {
          comparator = ">="
          value      = "99.00"
          palette    = "white_on_green"
        }
      }
      autoscale   = false
      custom_unit = "%"
      precision   = "2"
      text_align  = "right"
      title       = "Success Rate: ${var.name}"
      time = {
        live_span = "1h"
      }
    }
  }
  widget {
    service_level_objective_definition {
      title             = "${var.name} Availability (${var.filter_tags})"
      view_type         = "detail"
      slo_id            = datadog_service_level_objective.availability.id
      show_error_budget = true
      view_mode         = "overall"
      time_windows      = ["previous_week", "30d"]
    }
  }
}
