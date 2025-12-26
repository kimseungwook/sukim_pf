# NSG Outputs
output "lb_nsg_id" {
  description = "Load Balancer NSG OCID"
  value       = module.nsg.lb_nsg_id
}

output "cluster_nsg_id" {
  description = "OKE Cluster NSG OCID"
  value       = module.nsg.cluster_nsg_id
}

output "worker_nsg_id" {
  description = "Worker Node NSG OCID"
  value       = module.nsg.worker_nsg_id
}

output "pod_nsg_id" {
  description = "Pod NSG OCID"
  value       = module.nsg.pod_nsg_id
}

# VCN Outputs
output "vcn_id" {
  description = "VCN OCID"
  value       = module.vcn.vcn_id
}

output "subnet_public_id" {
  description = "Public Subnet OCID"
  value       = module.vcn.subnet_public_id
}

output "subnet_worker_id" {
  description = "Worker Subnet OCID"
  value       = module.vcn.subnet_worker_id
}

output "subnet_pod_id" {
  description = "Pod Subnet OCID"
  value       = module.vcn.subnet_pod_id
}
