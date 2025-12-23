# 1. Public Security List (LB, Bastion)
# 1. Public Security List (LB, Bastion)
resource "oci_core_security_list" "public_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_id
  display_name   = "sl-public-pf"

  # Ingress: Allow ALL
  ingress_security_rules {
    protocol  = "all"
    source    = "0.0.0.0/0"
    stateless = false
    description = "Allow all ingress"
  }
  
  # Egress: Allow all
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }
}

# 2. OKE API Security List
resource "oci_core_security_list" "oke_api_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_id
  display_name   = "sl-oke-api-pf"

  # Ingress: Allow ALL
  ingress_security_rules {
    protocol  = "all"
    source    = "0.0.0.0/0"
    stateless = false
    description = "Allow all ingress"
  }

  # Egress: Allow ALL
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }
}

# 3. Worker Security List
resource "oci_core_security_list" "worker_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_id
  display_name   = "sl-worker-pf"

  # Ingress: Allow ALL
  ingress_security_rules {
    protocol  = "all"
    source    = "0.0.0.0/0"
    stateless = false
    description = "Allow all ingress"
  }

  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }
}

# 4. Pod Security List
resource "oci_core_security_list" "pod_sl" {
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_id
  display_name   = "sl-pod-pf"

  # Ingress: Allow ALL
  ingress_security_rules {
    protocol  = "all"
    source    = "0.0.0.0/0"
    stateless = false
    description = "Allow all ingress"
  }

  # Egress: Allow all
  egress_security_rules {
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = false
  }
}


