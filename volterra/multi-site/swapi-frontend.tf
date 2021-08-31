resource "volterra_origin_pool" "frontend" {
  name                   = format("%s-fe", var.manifest_app_name)
  namespace              = volterra_namespace.ns.name
  depends_on             = [time_sleep.ns_wait]
  description            = format("Origin pool pointing to backend k8s service running in main-vsite")
  loadbalancer_algorithm = "ROUND ROBIN"
  origin_servers {
    k8s_service {
      inside_network  = false
      outside_network = false
      vk8s_networks   = true
      service_name    = format("${var.frontend_servicename}.%s", volterra_namespace.ns.name)
      site_locator {
        virtual_site {
          name      = volterra_virtual_site.main.name
          namespace = volterra_namespace.ns.name
        }
      }
    }
  }
  port               = 8080
  no_tls             = true
  endpoint_selection = "LOCAL_PREFERRED"
}

resource "volterra_http_loadbalancer" "frontend" {
  name                            = format("%s-fe", var.manifest_app_name)
  namespace                       = volterra_namespace.ns.name
  depends_on                      = [time_sleep.ns_wait]
  description                     = format("HTTP loadbalancer object for %s origin server", var.manifest_app_name)
  #domains                         = ["svk-demo-app-fe.sa.f5demos.com"]
  domains                         = ["${var.frontend_manifest_app_name}.${var.domain}"]
  advertise_on_public_default_vip = true
  #labels                          = { "ves.io/app_type" = volterra_app_type.at.name }
  default_route_pools {
    pool {
      name      = volterra_origin_pool.frontend.name
      namespace = volterra_namespace.ns.name
    }
  }
  https_auto_cert {
    add_hsts      = false
    http_redirect = true
    no_mtls       = true
  }
  more_option {
    response_headers_to_add {
        name   = "Access-Control-Allow-Origin"
        value  = "*"
        append = false
    }
  }
  disable_waf                     = true
  disable_rate_limit              = true
  round_robin                     = true
  service_policies_from_namespace = true
  no_challenge                    = true
}

output "fe-domain" { value = volterra_http_loadbalancer.frontend.domains }
