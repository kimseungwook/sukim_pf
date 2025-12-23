resource "oci_core_vcn" "vcn" {
  cidr_block     = var.primary_vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = var.vcn_name
  dns_label      = var.vcn_dns_label
}

# 1. Internet Gateway
resource "oci_core_internet_gateway" "ig" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = var.internet_gateway_name
  enabled        = true
}

# 2. NAT Gateway
resource "oci_core_nat_gateway" "nat" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = var.nat_gateway_name
}

# 3. Service Gateway
data "oci_core_services" "all_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
}

resource "oci_core_service_gateway" "sgw" {
  compartment_id = var.compartment_ocid
  services {
    service_id = data.oci_core_services.all_services.services[0].id
  }
  vcn_id       = oci_core_vcn.vcn.id
  display_name = var.service_gateway_name
}

# 4. DRG & CPE
resource "oci_core_drg" "drg" {
  compartment_id = var.compartment_ocid
  display_name   = var.drg_name
}

resource "oci_core_drg_attachment" "drg_attachment" {
  drg_id       = oci_core_drg.drg.id
  vcn_id       = oci_core_vcn.vcn.id
  display_name = var.drg_attachment_name
}

resource "oci_core_cpe" "cpe" {
  compartment_id = var.compartment_ocid
  ip_address     = var.cpe_ip
  display_name   = var.cpe_name
}

# ——————————————————————————————————————————————————————————————————————————————
# Route Tables
# ——————————————————————————————————————————————————————————————————————————————

# 1. Public RT (IGW)
resource "oci_core_route_table" "rt_public" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = var.route_table_public_name

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ig.id
  }
}

# 2. OKE API RT (NAT + SGW)
resource "oci_core_route_table" "rt_oke_api" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = var.route_table_oke_api_name

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat.id
  }
  route_rules {
    destination       = data.oci_core_services.all_services.services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.sgw.id
  }
}

# 3. Worker RT (NAT + SGW)
resource "oci_core_route_table" "rt_worker" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = var.route_table_worker_name

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat.id
  }
  route_rules {
    destination       = data.oci_core_services.all_services.services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.sgw.id
  }
}

# 4. Pod RT (NAT + SGW)
resource "oci_core_route_table" "rt_pod" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = var.route_table_pod_name

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat.id
  }
  route_rules {
    destination       = data.oci_core_services.all_services.services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.sgw.id
  }
}

# ——————————————————————————————————————————————————————————————————————————————
# Subnets
# ——————————————————————————————————————————————————————————————————————————————

# 1. Public Subnet
resource "oci_core_subnet" "subnet_public" {
  cidr_block        = var.subnet_public_cidr
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.vcn.id
  display_name      = var.subnet_public_name
  dns_label         = var.subnet_public_dns_label
  route_table_id    = oci_core_route_table.rt_public.id
  security_list_ids = [var.public_sl_id]
}

# 2. OKE API Subnet
resource "oci_core_subnet" "subnet_oke_api" {
  cidr_block        = var.subnet_oke_api_cidr
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.vcn.id
  display_name      = var.subnet_oke_api_name
  dns_label         = var.subnet_oke_api_dns_label
  route_table_id    = oci_core_route_table.rt_oke_api.id
  security_list_ids = [var.oke_api_sl_id]
  prohibit_public_ip_on_vnic = true
}

# 3. Worker Subnet
resource "oci_core_subnet" "subnet_worker" {
  cidr_block        = var.subnet_worker_cidr
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.vcn.id
  display_name      = var.subnet_worker_name
  dns_label         = var.subnet_worker_dns_label
  route_table_id    = oci_core_route_table.rt_worker.id
  security_list_ids = [var.worker_sl_id]
  prohibit_public_ip_on_vnic = true
}

# 4. Pod Subnet
resource "oci_core_subnet" "subnet_pod" {
  cidr_block        = var.subnet_pod_cidr
  compartment_id    = var.compartment_ocid
  vcn_id            = oci_core_vcn.vcn.id
  display_name      = var.subnet_pod_name
  dns_label         = var.subnet_pod_dns_label
  route_table_id    = oci_core_route_table.rt_pod.id
  security_list_ids = [var.pod_sl_id]
  prohibit_public_ip_on_vnic = true
}
