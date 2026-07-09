terraform {
  required_version = ">= 1.0"
}

variable "name" {
  description = "Name to include in the greeting."
  type        = string
  default     = "World"
}

variable "age" {
  description = "Age"
  type = number
  default = 18
}

locals {
  greeting = "Hello, ${var.name}! My age is ${var.age}"
}

output "hello_world" {
  description = "A friendly Terraform greeting."
  value       = local.greeting
}
