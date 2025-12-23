output "lb_nsg_id" {
  value = oci_core_network_security_group.lb_nsg.id
}

output "cluster_nsg_id" {
  value = oci_core_network_security_group.cluster_nsg.id
}

output "worker_nsg_id" {
  value = oci_core_network_security_group.worker_nsg.id
}

output "pod_nsg_id" {
  value = oci_core_network_security_group.pod_nsg.id
}