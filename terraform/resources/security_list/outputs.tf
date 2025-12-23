output "public_security_list_id" {
  description = "The OCID of the Public Security List."
  value       = oci_core_security_list.public_sl.id
}

output "oke_api_security_list_id" {
  description = "The OCID of the OKE API Security List."
  value       = oci_core_security_list.oke_api_sl.id
}

output "worker_security_list_id" {
  description = "The OCID of the Worker Security List."
  value       = oci_core_security_list.worker_sl.id
}

output "pod_security_list_id" {
  description = "The OCID of the Pod Security List."
  value       = oci_core_security_list.pod_sl.id
}