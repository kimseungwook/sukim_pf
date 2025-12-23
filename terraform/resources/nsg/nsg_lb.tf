# 1. Load Balancer NSG
# Purpose: Allow Public Access (HTTP/HTTPS) to Load Balancers
resource "oci_core_network_security_group" "lb_nsg" {
  compartment_id = var.compartment_ocid
  display_name   = "nsg-lb-pf"
  vcn_id         = var.vcn_id
}

# Ingress: Allow HTTP (80)
resource "oci_core_network_security_group_security_rule" "lb_ingress_http" {
  network_security_group_id = oci_core_network_security_group.lb_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = "0.0.0.0/0"
  stateless                 = false
  description               = "Allow HTTP from anywhere"
  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

# Ingress: Allow HTTPS (443)
resource "oci_core_network_security_group_security_rule" "lb_ingress_https" {
  network_security_group_id = oci_core_network_security_group.lb_nsg.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = "0.0.0.0/0"
  stateless                 = false
  description               = "Allow HTTPS from anywhere"
  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

# Egress: Allow all
resource "oci_core_network_security_group_security_rule" "lb_egress_all" {
  network_security_group_id = oci_core_network_security_group.lb_nsg.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  stateless                 = false
  description               = "Allow all egress from LB"
}
