# 2. OKE Cluster (Control Plane) NSG
# Purpose: Secure Kubernetes API Endpoint
resource "oci_core_network_security_group" "cluster_nsg" {
  compartment_id = var.compartment_ocid
  display_name   = "nsg-cluster-pf"
  vcn_id         = var.vcn_id
}

# Ingress: From Worker Nodes, Pods, Bastion (VCN Internal)
# Ingress: Allow ALL traffic (Permissive Mode for Debugging/Portfolio)
resource "oci_core_network_security_group_security_rule" "cluster_ingress_all" {
  network_security_group_id = oci_core_network_security_group.cluster_nsg.id
  direction                 = "INGRESS"
  protocol                  = "all"
  source                    = "0.0.0.0/0"
  stateless                 = false
  description               = "Allow all ingress for debugging"
}



# Egress: All to VCN (Control Plane must communicate with workers on multiple ports)
resource "oci_core_network_security_group_security_rule" "cluster_egress_vcn_all" {
  network_security_group_id = oci_core_network_security_group.cluster_nsg.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = var.vcn_cidr
  stateless                 = false
  description               = "Allow all egress to VCN for OKE control plane"
}

# Egress: To OCI Services
resource "oci_core_network_security_group_security_rule" "cluster_egress_oci" {
  network_security_group_id = oci_core_network_security_group.cluster_nsg.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "all-icn-services-in-oracle-services-network"
  destination_type          = "SERVICE_CIDR_BLOCK"
  stateless                 = false
  description               = "Allow Cluster to OCI Services"
}

# Ingress: ICMP from VCN (for path MTU discovery)
resource "oci_core_network_security_group_security_rule" "cluster_ingress_icmp" {
  network_security_group_id = oci_core_network_security_group.cluster_nsg.id
  direction                 = "INGRESS"
  protocol                  = "1" # ICMP
  source                    = var.vcn_cidr
  stateless                 = false
  icmp_options {
    type = 3
    code = 4
  }
  description = "Allow ICMP fragmentation from VCN"
}

