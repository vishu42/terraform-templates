terraform {
  required_version = ">= 1.0"
}

variable "function_name" {
  description = "Name of the Lambda function."
  type        = string
  default     = "process-orders"
}

variable "runtime" {
  description = "Lambda runtime identifier."
  type        = string
  default     = "nodejs20.x"

  validation {
    condition     = contains(["nodejs18.x", "nodejs20.x", "python3.12", "python3.11", "go1.x", "java21"], var.runtime)
    error_message = "Unsupported runtime. Choose from: nodejs18.x, nodejs20.x, python3.12, python3.11, go1.x, java21."
  }
}

variable "handler" {
  description = "Function handler entry point."
  type        = string
  default     = "index.handler"
}

variable "memory_size" {
  description = "Memory allocated to the function (MB)."
  type        = number
  default     = 256

  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 10240
    error_message = "Memory must be between 128 and 10240 MB."
  }
}

variable "timeout" {
  description = "Function timeout in seconds."
  type        = number
  default     = 30
}

variable "environment_vars" {
  description = "Environment variables for the function."
  type        = map(string)
  default = {
    LOG_LEVEL = "info"
    REGION    = "us-east-1"
  }
}

locals {
  function_arn   = "arn:aws:lambda:us-east-1:123456789012:function:${var.function_name}"
  runtime_family = split(".", var.runtime)[0] == "nodejs" ? "JavaScript" : split(".", var.runtime)[0] == "python" ? "Python" : split(".", var.runtime)[0] == "go" ? "Go" : "Java"
  env_vars_json  = jsonencode(var.environment_vars)
  cost_tier      = var.memory_size <= 512 ? "low" : var.memory_size <= 2048 ? "medium" : "high"
}

output "function_arn" {
  description = "ARN of the Lambda function."
  value       = local.function_arn
}

output "runtime_family" {
  description = "Language family detected from runtime."
  value       = local.runtime_family
}

output "environment_variables" {
  description = "Environment variables as JSON."
  value       = local.env_vars_json
}

output "cost_tier" {
  description = "Estimated cost tier based on memory."
  value       = local.cost_tier
}

output "timeout_seconds" {
  description = "Configured timeout."
  value       = var.timeout
}
