variable "compartment_ocid" {
  type = string
}
variable "primary_vcn_cidr" {
  type = string
}

variable "vcn_name" {
  type = string
}
variable "vcn_dns_label" {
  type = string
}

# Subnets
variable "subnet_public_cidr" {
  type = string
}
variable "subnet_public_name" {
  type = string
}
variable "subnet_public_dns_label" {
  type = string
}

variable "subnet_oke_api_cidr" {
  type = string
}
variable "subnet_oke_api_name" {
  type = string
}
variable "subnet_oke_api_dns_label" {
  type = string
}

variable "subnet_worker_cidr" {
  type = string
}
variable "subnet_worker_name" {
  type = string
}
variable "subnet_worker_dns_label" {
  type = string
}

variable "subnet_pod_cidr" {
  type = string
}
variable "subnet_pod_name" {
  type = string
}
variable "subnet_pod_dns_label" {
  type = string
}

# Security List IDs
variable "public_sl_id" {
  type = string
}
variable "oke_api_sl_id" {
  type = string
}
variable "worker_sl_id" {
  type = string
}
variable "pod_sl_id" {
  type = string
}

# Gateways
variable "internet_gateway_name" {
  type = string
}
variable "nat_gateway_name" {
  type = string
}
variable "service_gateway_name" {
  type = string
}
variable "drg_name" {
  type = string
}
variable "drg_attachment_name" {
  type = string
}
variable "cpe_name" {
  type = string
}
variable "cpe_ip" {
  type = string
}

# Route Tables
variable "route_table_public_name" {
  type = string
}
variable "route_table_oke_api_name" {
  type = string
}
variable "route_table_worker_name" {
  type = string
}
variable "route_table_pod_name" {
  type = string
}
