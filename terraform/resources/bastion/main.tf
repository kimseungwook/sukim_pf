resource "oci_bastion_bastion" "hyper_report_bastion" {
  bastion_type = "STANDARD"
  compartment_id  = var.compartment_ocid
  target_subnet_id  = var.subnet_service_id
  name = "sukim-web-bastion"
  client_cidr_block_allow_list = ["0.0.0.0/0"] # Replace with specific CIDRs as needed

  # Optional parameters
  max_session_ttl_in_seconds = 10800  # 3 hours
}
