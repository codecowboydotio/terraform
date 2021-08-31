#!/usr/bin/bash
#kubectl --kubeconfig ./default-vk8s.yaml apply -f a.yml

namespace=$1
if [ -z $namespace ] 
then
  please provide namespace as first argument
  exit 1
fi

echo "Virtual Site info"
/root/vesctl.linux-amd64 --p12-bundle /root/f5-sa.console.ves.volterra.io.api-creds.p12 configuration get virtual_site -n $namespace

echo
echo "Virtual k8s info for $namespace"
/root/vesctl.linux-amd64 --p12-bundle /root/f5-sa.console.ves.volterra.io.api-creds.p12  configuration get virtual_k8s -n $namespace
echo
echo "http load balancer info for namespace $namespace"
/root/vesctl.linux-amd64 --p12-bundle /root/f5-sa.console.ves.volterra.io.api-creds.p12 configuration get http_loadbalancer -n $namespace
echo
echo "origin pools for namespace $namespace"
/root/vesctl.linux-amd64 --p12-bundle /root/f5-sa.console.ves.volterra.io.api-creds.p12 configuration get origin_pool -n $namespace
echo
echo "healthcheck"
/root/vesctl.linux-amd64 --p12-bundle /root/f5-sa.console.ves.volterra.io.api-creds.p12 configuration get healthcheck


echo "------------------------------------------------------"
echo "Deployments"
kubectl --kubeconfig ./default-vk8s.yaml describe deployments
echo
echo "Services"
kubectl --kubeconfig ./default-vk8s.yaml describe services
echo
echo "pods"
kubectl --kubeconfig ./default-vk8s.yaml describe pods

