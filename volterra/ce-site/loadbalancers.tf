resource "volterra_tcp_loadbalancer" "unit-config" {
  name      = "svk-config"
  namespace = var.ns

  listen_port = "4444"
  dns_volterra_managed = true
  domains = ["svk-demo-app.sa.f5demos.com"]
  advertise_on_public_default_vip = true

  retract_cluster = true

  origin_pools_weights { 
    pool {
      name = "unit-git-origin"
      namespace = "s-vankalken2"
    }
  }

  hash_policy_choice_round_robin = true
}
