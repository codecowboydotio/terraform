resource "volterra_tcp_loadbalancer" "unit-config" {
  for_each  = var.tcp_lb
  name      = "${each.key}"
  namespace = var.ns

  listen_port = "${each.value}"
  dns_volterra_managed = true
  domains = ["${var.domain_host}.${var.domain}"]
  advertise_on_public_default_vip = true

  retract_cluster = true

  origin_pools_weights { 
    pool {
      name = "${each.key}"
      namespace = var.ns
    }
  }

  hash_policy_choice_round_robin = true
}
