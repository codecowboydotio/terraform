provider "volterra" {
  api_p12_file     = "/root/f5-sa.console.ves.volterra.io.api-creds.p12"
  url              = "https://f5-sa.console.ves.volterra.io/api"
}

resource "volterra_namespace" "example" {
  name = "s-vankalken"
}

resource "volterra_virtual_site" "main" {
  #name      = format("%s-vs", volterra_namespace.example.name)
  name = "s-vankalken-vs"
  namespace = volterra_namespace.example.name
  depends_on = [time_sleep.ns_wait]

  site_selector {
    expressions =  ["ves.io/siteName in (ves-io-ny8-nyc)"]
  }
  site_type = "REGIONAL_EDGE"
}

resource "time_sleep" "ns_wait" {
  depends_on = [volterra_namespace.example]
  create_duration = "15s"
}

resource "volterra_virtual_k8s" "vk8s" {
  name      = format("%s-vk8s", volterra_namespace.example.name)
  namespace = volterra_namespace.example.name
  depends_on = [time_sleep.ns_wait]

  vsite_refs {
    name      = volterra_virtual_site.main.name
    namespace = volterra_namespace.example.name
  }
}

resource "time_sleep" "vk8s_wait" {
  depends_on = [volterra_virtual_k8s.vk8s]
  create_duration = "150s"
}

resource "volterra_api_credential" "cred" {
  name      = format("%s-api-cred", "demo-app")
  api_credential_type = "KUBE_CONFIG"
  virtual_k8s_namespace = volterra_namespace.example.name
  virtual_k8s_name = volterra_virtual_k8s.vk8s.name
  depends_on = [time_sleep.vk8s_wait]
}

resource "local_file" "kubeconfig" {
    content = base64decode(volterra_api_credential.cred.data)
    filename = format("%s/%s", path.module, format("%s-vk8s.yaml", terraform.workspace))
}

resource "volterra_app_type" "at" {
  // This naming simplifies the 'mesh' cards
  name      = "s-vankalken-demo-app"
  namespace = "shared"
  features {
    type = "BUSINESS_LOGIC_MARKUP"
  }
  features {
    type = "USER_BEHAVIOR_ANALYSIS"
  }
  features {
    type = "PER_REQ_ANOMALY_DETECTION"
  }
  features {
    type = "TIMESERIES_ANOMALY_DETECTION"
  }
  business_logic_markup_setting {
    enable = true
  }
}
