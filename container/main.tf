terraform {
  required_version = ">= 1.0"
}

variable "container_name" {
  description = "Name of the container."
  type        = string
  default     = "web-app"
}

variable "image" {
  description = "Docker image to deploy."
  type        = string
  default     = "nginx:1.25"
}

variable "cpu" {
  description = "CPU units for the container (1024 = 1 vCPU)."
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory for the container (MB)."
  type        = number
  default     = 512
}

variable "port_mappings" {
  description = "Port mappings for the container."
  type = list(object({
    container_port = number
    host_port      = optional(number)
    protocol       = optional(string, "tcp")
  }))
  default = [
    { container_port = 80, host_port = 8080, protocol = "tcp" },
    { container_port = 443 },
  ]
}

variable "health_check" {
  description = "Health check configuration."
  type = object({
    path     = optional(string, "/")
    interval = optional(number, 30)
    timeout  = optional(number, 5)
    retries  = optional(number, 3)
  })
  default = {
    path     = "/health"
    interval = 60
    retries  = 5
  }
}

locals {
  image_registry = split(":", var.image)[0] == var.image ? "docker.io" : "docker.io"
  image_tag      = length(split(":", var.image)) > 1 ? split(":", var.image)[1] : "latest"
  port_list      = [for p in var.port_mappings : "${p.protocol}:${coalesce(p.host_port, p.container_port)}->${p.container_port}"]
  ports_formatted = join(", ", local.port_list)
  health_endpoint = "${var.health_check.path} (interval=${var.health_check.interval}s, timeout=${var.health_check.timeout}s, retries=${var.health_check.retries})"
  resource_label  = "${var.cpu / 1024} vCPU / ${var.memory} MB"
}

output "image_full" {
  description = "Full image reference with registry."
  value       = "${local.image_registry}/${var.image}"
}

output "image_tag" {
  description = "Extracted image tag."
  value       = local.image_tag
}

output "ports" {
  description = "Container port mappings."
  value       = local.ports_formatted
}

output "health_check_config" {
  description = "Health check endpoint and settings."
  value       = local.health_endpoint
}

output "resources" {
  description = "Allocated compute resources."
  value       = local.resource_label
}
