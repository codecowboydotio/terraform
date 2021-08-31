provider "kubectl" {
  config_path = "./default-vk8s.yaml"
}

##############
#
# Deploy frontend to one namespace
#
#############
data "kubectl_path_documents" "manifests" {
  pattern = "./manifests/*.yml"
  vars = {
      namespace  = var.ns
      manifest_app_name = var.manifest_app_name
      frontend_manifest_app_name = var.frontend_manifest_app_name
      frontend_service_name = var.frontend_servicename
      servicename = var.servicename
      domain = var.domain
      vehicles_manifest_app_name = var.vehicles_manifest_app_name
      vehicles_servicename = var.vehicles_servicename
      starships_manifest_app_name = var.starships_manifest_app_name
      starships_servicename = var.starships_servicename
      people_manifest_app_name = var.people_manifest_app_name
      people_servicename = var.people_servicename
      planets_manifest_app_name = var.planets_manifest_app_name
      planets_servicename = var.planets_servicename
  }
}

resource "kubectl_manifest" "documents" {
    count     = length(data.kubectl_path_documents.manifests.documents)
    yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
#    //This provider doesn't enforce NS from kubeconfig context
    override_namespace = var.ns
    depends_on = [local_file.kubeconfig, data.kubectl_path_documents.manifests]
}

