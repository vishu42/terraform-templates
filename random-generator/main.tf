terraform {
  required_version = ">= 1.0"
}

variable "name_prefix" {
  description = "Prefix for generated resource names."
  type        = string
  default     = "demo"
}

variable "length" {
  description = "Length of generated random strings."
  type        = number
  default     = 8

  validation {
    condition     = var.length >= 4 && var.length <= 64
    error_message = "Length must be between 4 and 64."
  }
}

variable "special_chars" {
  description = "Include special characters in passwords."
  type        = bool
  default     = false
}

variable "suffix_count" {
  description = "Number of random suffixes to generate."
  type        = number
  default     = 4
}

locals {
  timestamp    = formatdate("YYYYMMDD-hhmmss", timestamp())
  random_name  = "${var.name_prefix}-${local.timestamp}"
  short_id     = substr(md5(local.random_name), 0, var.length)

  charset_base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  charset_full = "${local.charset_base}!@#$%&*"
  charset      = var.special_chars ? local.charset_full : local.charset_base

  suffixes = [for i in range(var.suffix_count) : substr(md5("${local.random_name}-${i}"), 0, 6)]

  password_parts = [
    substr(local.charset, 0, 1),
    substr(local.charset, 26, 1),
    substr(local.charset, 52, 1),
    substr(local.charset, 62, 1),
    substr(md5(local.random_name), 0, var.length - 4),
  ]
  password = join("", local.password_parts)
}

output "random_name" {
  description = "Timestamp-based random name."
  value       = local.random_name
}

output "short_id" {
  description = "Short random identifier."
  value       = local.short_id
}

output "suffixes" {
  description = "List of generated random suffixes."
  value       = local.suffixes
}

output "password" {
  description = "Generated password string."
  value       = local.password
  sensitive   = true
}

output "charset_used" {
  description = "Character set used for generation."
  value       = var.special_chars ? "alphanumeric + special" : "alphanumeric only"
}
