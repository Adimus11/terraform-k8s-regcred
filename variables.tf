variable "default_secret_name" {
  type        = string
  default     = "regcred"
  description = "Name used for creating registry password by default, default name is: regcred"
}

variable "registries" {
  type = list(object({
    uri        = string
    username   = string
    namespaces = set(string)
  }))
  description = "List of registries URIs and logins with namespaces where secrets should be created"

  validation {
    condition = alltrue([
      for registry in var.registries : length(registry.namespaces) > 0
    ])
    error_message = "At least one namespace should be provided per secret"
  }
}

variable "registry_passwords" {
  sensitive   = true
  type        = map(string)
  description = "Map of mappings from registry uri -> registry_password"
}

variable "overwrite" {
  type        = map(string)
  description = "Overwrite name of the secret for given namespace"
  default     = {}
}
