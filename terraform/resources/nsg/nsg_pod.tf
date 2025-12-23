# 4. Pod NSG
# Purpose: Rules for Pod-to-Pod and Pod-to-World communication
resource "oci_core_network_security_group" "pod_nsg" {
  compartment_id = var.compartment_ocid
  display_name   = "nsg-pod-pf"
  vcn_id         = var.vcn_id
}

# Ingress: From VCN (Workers, LB, other Pods)
resource "oci_core_network_security_group_security_rule" "pod_ingress_vcn" {
  network_security_group_id = oci_core_network_security_group.pod_nsg.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source                    = var.vcn_cidr
  stateless                 = false
  description               = "Allow all from VCN"
}

# Ingress: From Pod Subnet (Self) - Redundant if VCN covers it, but good for explicit rule
resource "oci_core_network_security_group_security_rule" "pod_ingress_self" {
  network_security_group_id = oci_core_network_security_group.pod_nsg.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source                    = var.subnet_pod_cidr_block
  stateless                 = false
  description               = "Allow all Pod-to-Pod"
}

# Egress: Allow all
resource "oci_core_network_security_group_security_rule" "pod_egress_all" {
  network_security_group_id = oci_core_network_security_group.pod_nsg.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  stateless                 = false
  description               = "Allow all egress from Pods"
}
