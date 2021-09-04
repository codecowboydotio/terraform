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
      loadgen_manifest_app_name = var.loadgen_manifest_app_name
      servicename = var.servicename
      domain = var.domain
  }
}

resource "kubectl_manifest" "documents" {
    count     = length(data.kubectl_path_documents.manifests.documents)
    yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
#    //This provider doesn't enforce NS from kubeconfig context
    override_namespace = var.ns
    depends_on = [local_file.kubeconfig, data.kubectl_path_documents.manifests]
}

