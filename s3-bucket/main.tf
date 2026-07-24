terraform {
  required_version = ">= 1.0"
}

variable "bucket_name" {
  description = "Name of the S3 bucket."
  type        = string
  default     = "my-app-bucket"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "versioning_enabled" {
  description = "Enable bucket versioning."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to the bucket."
  type        = map(string)
  default = {
    Owner       = "platform-team"
    CostCenter  = "engineering"
  }
}

locals {
  bucket_arn  = "arn:aws:s3:::${var.bucket_name}-${var.environment}"
  bucket_fqdn = "${var.bucket_name}-${var.environment}.s3.amazonaws.com"
  versioning  = var.versioning_enabled ? "Enabled" : "Suspended"
  tag_list    = join(", ", [for k, v in var.tags : "${k}=${v}"])
}

output "bucket_arn" {
  description = "ARN of the S3 bucket."
  value       = local.bucket_arn
}

output "bucket_fqdn" {
  description = "Fully qualified domain name of the bucket."
  value       = local.bucket_fqdn
}

output "versioning_status" {
  description = "Bucket versioning configuration status."
  value       = local.versioning
}

output "tags_summary" {
  description = "Comma-separated tags."
  value       = local.tag_list
}
