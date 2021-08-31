provider "kubectl" {
  alias = "be"
  config_path = "./default-be-vk8s.yaml"
}

##############
#
# Deploy backend to one namespace
#
#############
data "kubectl_path_documents" "be-manifests" {
  pattern = "./manifests/*backend.yml"
  vars = {
      namespace  = var.be-ns
      manifest_app_name = var.manifest_app_name
      frontend_manifest_app_name = var.frontend_manifest_app_name
      frontend_service_name = var.frontend_servicename
      servicename = var.servicename
      domain = var.domain
  }
}

resource "kubectl_manifest" "be-documents" {
    provider = kubectl.be
    count     = length(data.kubectl_path_documents.be-manifests.documents)
    yaml_body = element(data.kubectl_path_documents.be-manifests.documents, count.index)
#    //This provider doesn't enforce NS from kubeconfig context
    override_namespace = var.be-ns
    depends_on = [local_file.be-kubeconfig, data.kubectl_path_documents.be-manifests]
}
