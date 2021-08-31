resource "volterra_namespace" "be-ns" {
  name = var.be-ns
}

resource "time_sleep" "be-ns_wait" {
  depends_on = [volterra_namespace.be-ns]
  create_duration = "15s"
}


resource "volterra_virtual_site" "be-vs" {
  name      = format("%s-vs", volterra_namespace.be-ns.name)
  namespace = volterra_namespace.be-ns.name
  depends_on = [time_sleep.be-ns_wait]

  site_selector {
    expressions = var.be_site_selector
  }
  site_type = "REGIONAL_EDGE"
}


resource "time_sleep" "be_vk8s_wait" {
  create_duration = "120s"
  depends_on = [volterra_virtual_site.be-vs]
}


resource "volterra_virtual_k8s" "be-vk8s" {
  name      = format("%s-vk8s", volterra_namespace.be-ns.name)
  namespace = volterra_namespace.be-ns.name
  depends_on = [volterra_virtual_site.be-vs]

  vsite_refs {
    name      = volterra_virtual_site.be-vs.name
    namespace = volterra_namespace.be-ns.name
  }
}


resource "volterra_api_credential" "be-cred" {
  name      = format("%s-beapi-cred", var.manifest_app_name)
  api_credential_type = "KUBE_CONFIG"
  virtual_k8s_namespace = volterra_namespace.be-ns.name
  virtual_k8s_name = volterra_virtual_k8s.be-vk8s.name
}

resource "time_sleep" "be-vk8s_cred_wait" {
  create_duration = "30s"
  depends_on = [volterra_api_credential.be-cred]
}

resource "local_file" "be-kubeconfig" {
    content = base64decode(volterra_api_credential.be-cred.data)
    filename = format("%s/%s", path.module, format("%s-be-vk8s.yaml", terraform.workspace))

    depends_on = [time_sleep.be-vk8s_cred_wait]
}

#resource "volterra_origin_pool" "backend" {
#  name                   = format("%s-be", var.manifest_app_name)
#  namespace              = volterra_namespace.ns.name
#  depends_on             = [time_sleep.ns_wait]
#  description            = format("Origin pool pointing to backend k8s service running in main-vsite")
#  loadbalancer_algorithm = "ROUND ROBIN"
#  origin_servers {
#    k8s_service {
#      inside_network  = false
#      outside_network = false
#      vk8s_networks   = true
#      service_name    = format("${var.servicename}.%s", volterra_namespace.ns.name)
#      site_locator {
#        virtual_site {
#          name      = volterra_virtual_site.main.name
#          namespace = volterra_namespace.ns.name
#        }
#      }
#    }
#  }
#  port               = 3000
#  no_tls             = true
#  endpoint_selection = "LOCAL_PREFERRED"
#}
#
#resource "volterra_http_loadbalancer" "backend" {
#  name                            = format("%s-be", var.manifest_app_name)
#  namespace                       = volterra_namespace.ns.name
#  depends_on                      = [time_sleep.ns_wait]
#  description                     = format("HTTP loadbalancer object for %s origin server", var.manifest_app_name)
#  #domains                         = ["svk-demo-app.sa.f5demos.com"]
#  domains                         = ["${var.manifest_app_name}.${var.domain}"]
#  advertise_on_public_default_vip = true
#  labels                          = { "ves.io/app_type" = volterra_app_type.at.name }
#  default_route_pools {
#    pool {
#      name      = volterra_origin_pool.backend.name
#      namespace = volterra_namespace.ns.name
#    }
#  }
#  https_auto_cert {
#    add_hsts      = false
#    http_redirect = true
#    no_mtls       = true
#  }
#  more_option {
#    response_headers_to_add {
#        name   = "Access-Control-Allow-Origin"
#        value  = "*"
#        append = false
#    }
#  }
#  disable_waf                     = true
#  disable_rate_limit              = true
#  round_robin                     = true
#  service_policies_from_namespace = true
#  no_challenge                    = true
#}
#
#resource "volterra_app_type" "at" {
#  // This naming simplifies the 'mesh' cards
#  name      = var.manifest_app_name
#  namespace = "shared"
#  features {
#    type = "BUSINESS_LOGIC_MARKUP"
#  }
#  features {
#    type = "USER_BEHAVIOR_ANALYSIS"
#  }
#  features {
#    type = "PER_REQ_ANOMALY_DETECTION"
#  }
#  features {
#    type = "TIMESERIES_ANOMALY_DETECTION"
#  }
#  business_logic_markup_setting {
#    enable = true
#  }
#}
#
#output "domain" { value = "${var.manifest_app_name}.${var.domain}" }
