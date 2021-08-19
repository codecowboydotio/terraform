provider "kubectl" {
  config_path = "./default-vk8s.yaml"
}

data "kubectl_path_documents" "manifests" {
  pattern = "./manifests/*.yml"
  vars = {
      namespace  = var.ns
      manifest_app_name = var.manifest_app_name
      servicename = var.servicename
  }
}

resource "kubectl_manifest" "documents" {
    count     = length(data.kubectl_path_documents.manifests.documents)
    yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
#    //This provider doesn't enforce NS from kubeconfig context
    override_namespace = "s-vankalken"
    depends_on = [local_file.kubeconfig, data.kubectl_path_documents.manifests]
}
