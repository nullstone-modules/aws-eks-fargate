variable "log_retention_in_days" {
  type        = number
  default     = 365
  description = <<EOF
This defines the retention period for the CloudWatch logs for this Kubernetes cluster.
EOF

  validation {
    condition     = var.log_retention_in_days >= 1
    error_message = "log_retention_in_days must be at least 1 day"
  }
}
