provider "kubectl" {
  config_path = "./default-vk8s.yaml"
}

data "kubectl_path_documents" "manifests" {
  pattern = "./manifests/*.yml"
}

resource "kubectl_manifest" "documents" {
    count     = length(data.kubectl_path_documents.manifests.documents)
    yaml_body = element(data.kubectl_path_documents.manifests.documents, count.index)
#    //This provider doesn't enforce NS from kubeconfig context
    override_namespace = "s-vankalken"
}


output "unit_server_ip" {
  value = data.kubectl_path_documents.manifests
  sensitive = true
}

output "foo" {
  value = kubectl_manifest.documents
  sensitive = true
}
