locals {
  # Auto-generated names (readable + compliant)
  rg_name = format("rg-%s-%s", var.app, var.environment)

  # Key Vault: lowercase, hyphens allowed, max 24 chars
  kv_name = substr(lower(format("kv-%s-%s", var.app, var.environment)), 0, 24)

  # Fabric capacity: letters+numbers only, 3–63 chars, must start with a letter
  fabcap_name_default  = lower(format("fabcap%s%s", var.app, var.environment))
  fabric_capacity_name = coalesce(var.fabric_capacity_name, local.fabcap_name_default)

  # Storage account style (only if you create one): letters+numbers only, max 24
  sa_name = substr(lower(format("st%s%s", var.app, var.environment)), 0, 24)

  # Display prefix for SPNs etc.
  name_prefix_effective = format("%s-%s", var.app, var.environment)
  env_lc                = lower(var.environment)

  # Tags
  tags_effective = merge(var.tags, { Environment = upper(local.env_lc) })
}

