output "cluster_id" {
  description = "The OCID of the OKE cluster"
  value       = oci_containerengine_cluster.oke_cluster.id
}

output "node_pool_ids" {
  description = "The OCIDs of the node pools"
  value       = { for k, v in oci_containerengine_node_pool.node_pool : k => v.id }
}

# Virtual Node Pool outputs 추가
output "virtual_node_pool_ids" {
  description = "The OCIDs of the virtual node pools"
  value       = { for k, v in oci_containerengine_virtual_node_pool.virtual_node_pool : k => v.id }
}