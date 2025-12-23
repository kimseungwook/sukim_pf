output "vcn_id" {
  value = oci_core_vcn.vcn.id
}
output "vcn_cidr_block" {
  value = oci_core_vcn.vcn.cidr_block
}

# Subnet IDs
output "subnet_public_id" {
  value = oci_core_subnet.subnet_public.id
}
output "subnet_oke_api_id" {
  value = oci_core_subnet.subnet_oke_api.id
}
output "subnet_worker_id" {
  value = oci_core_subnet.subnet_worker.id
}
output "subnet_pod_id" {
  value = oci_core_subnet.subnet_pod.id
}

# Subnet CIDRs
output "subnet_public_cidr" {
  value = oci_core_subnet.subnet_public.cidr_block
}
output "subnet_worker_cidr" {
  value = oci_core_subnet.subnet_worker.cidr_block
}
output "subnet_pod_cidr" {
  value = oci_core_subnet.subnet_pod.cidr_block
}

# Gateway IDs
output "ig_id" {
  value = oci_core_internet_gateway.ig.id
}
output "nat_id" {
  value = oci_core_nat_gateway.nat.id
}
output "sgw_id" {
  value = oci_core_service_gateway.sgw.id
}
output "drg_id" {
  value = oci_core_drg.drg.id
}

# Route Table IDs
output "route_table_public_id" {
  value = oci_core_route_table.rt_public.id
}
output "route_table_oke_api_id" {
  value = oci_core_route_table.rt_oke_api.id
}
output "route_table_worker_id" {
  value = oci_core_route_table.rt_worker.id
}
output "route_table_pod_id" {
  value = oci_core_route_table.rt_pod.id
}