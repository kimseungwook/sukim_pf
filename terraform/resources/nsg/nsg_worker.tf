# 3. Worker Node NSG
# Purpose: Rules for Worker Node VMs
resource "oci_core_network_security_group" "worker_nsg" {
  compartment_id = var.compartment_ocid
  display_name   = "nsg-worker-pf"
  vcn_id         = var.vcn_id
}


# Ingress: All from VCN (NodePorts, Health Checks)
# Ingress: Allow ALL traffic (Permissive Mode for Debugging/Portfolio)
resource "oci_core_network_security_group_security_rule" "worker_ingress_all" {
  network_security_group_id = oci_core_network_security_group.worker_nsg.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source                    = "0.0.0.0/0"
  stateless                 = false
  description = "Allow all ingress for debugging"
}

# Egress: Allow all
resource "oci_core_network_security_group_security_rule" "worker_egress_all" {
  network_security_group_id = oci_core_network_security_group.worker_nsg.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  stateless                 = false
  description               = "Allow all egress from Workers"
}
