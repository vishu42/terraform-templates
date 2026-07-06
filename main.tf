terraform {
  required_version = ">= 1.0"
}

variable "name" {
  description = "Name to include in the greeting."
  type        = string
  default     = "World"
}

locals {
  greeting = "Hello, ${var.name}!"
}

output "hello_world" {
  description = "A friendly Terraform greeting."
  value       = local.greeting
}
