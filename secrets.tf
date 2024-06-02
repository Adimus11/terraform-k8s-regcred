locals {
  all_namepsaces = toset([
    for v in flatten(var.registries[*].namespaces) : v
  ])
}

resource "kubernetes_secret" "registry_credentials" {
  for_each = local.all_namepsaces

  metadata {
    name      = lookup(var.overwrite, each.key, var.default_secret_name)
    namespace = each.key
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        for registry in var.registries :
        registry.uri => {
          "username" = registry.username
          "password" = var.registry_passwords[registry.uri]
          "auth"     = base64encode("${registry.username}:${var.registry_passwords[registry.uri]}")
        } if contains(registry.namespaces, each.key)
      }
    })
  }
}
