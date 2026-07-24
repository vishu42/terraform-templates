terraform {
  required_version = ">= 1.0"
}

variable "vpc_name" {
  description = "Name of the VPC."
  type        = string
  default     = "main-vpc"
}

variable "cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.cidr_block, 0))
    error_message = "Must be a valid IPv4 CIDR block."
  }
}

variable "subnet_count" {
  description = "Number of subnets to create."
  type        = number
  default     = 3
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC."
  type        = bool
  default     = true
}

locals {
  subnet_bits   = 8
  subnet_cidrs  = [for i in range(var.subnet_count) : cidrsubnet(var.cidr_block, local.subnet_bits, i)]
  subnet_list   = join("\n  - ", local.subnet_cidrs)
  dns_setting   = var.enable_dns_hostnames ? "enabled" : "disabled"
  total_ips     = pow(2, 32 - split("/", var.cidr_block)[1]) - 5
}

output "vpc_id" {
  description = "Logical identifier of the VPC."
  value       = "vpc-${md5(var.vpc_name)}"
}

output "subnets" {
  description = "List of subnet CIDR blocks."
  value       = local.subnet_cidrs
}

output "subnets_formatted" {
  description = "Formatted subnet listing."
  value       = "Subnets:\n  - ${local.subnet_list}"
}

output "dns_hostnames" {
  description = "DNS hostnames setting."
  value       = local.dns_setting
}

output "available_ips" {
  description = "Approximate usable IPs in the VPC."
  value       = local.total_ips
}
