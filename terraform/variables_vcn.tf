variable "primary_vcn_cidr" {
    type = string
    default = "10.200.0.0/16"
}

variable "vcn_name" {
    type = string
    default = "sukim-vcn-pf"
}
variable "vcn_dns_label" {
    type = string
    default = "pfsvcrun"
}

# 1. Public Subnet (LB, NAT, Bastion)
variable "subnet_public_cidr" {
    type = string
    default = "10.200.1.0/24"
}
variable "subnet_public_name" {
    type = string
    default = "subnet-public-pf"
}
variable "subnet_public_dns_label" {
    type = string
    default = "public"
}

# 2. OKE API Endpoint Subnet
variable "subnet_oke_api_cidr" {
    type = string
    default = "10.200.10.0/28"
}
variable "subnet_oke_api_name" {
    type = string
    default = "subnet-oke-api-pf"
}
variable "subnet_oke_api_dns_label" {
    type = string
    default = "okeapi"
}

# 3. Worker Nodes Subnet
variable "subnet_worker_cidr" {
    type = string
    default = "10.200.20.0/23"
}
variable "subnet_worker_name" {
    type = string
    default = "subnet-worker-pf"
}
variable "subnet_worker_dns_label" {
    type = string
    default = "worker"
}

# 4. Pods Subnet (All Workloads)
variable "subnet_pod_cidr" {
    type = string
    default = "10.200.32.0/22"
}
variable "subnet_pod_name" {
    type = string
    default = "subnet-pod-pf"
}
variable "subnet_pod_dns_label" {
    type = string
    default = "pod"
}

# Gateway Names
variable "internet_gateway_name" {
    type = string
    default = "internet-gateway-pf"
}
variable "nat_gateway_name" {
    type = string
    default = "nat-gateway-pf"
}
variable "service_gateway_name" {
    type = string
    default = "service-gateway-pf"
}
variable "drg_name" {
    type = string
    default = "drg-pf"
}
variable "drg_attachment_name" {
    type = string
    default = "drg-attachment-pf"
}
variable "cpe_name" {
    type = string
    default = "office-cpe-pf"
}
variable "cpe_ip" {
    type = string
    default = "211.192.161.33"
}

# Route Table Names
variable "route_table_public_name" {
    type = string
    default = "rt-public-pf"
}
variable "route_table_oke_api_name" {
    type = string
    default = "rt-oke-api-pf"
}
variable "route_table_worker_name" {
    type = string
    default = "rt-worker-pf"
}
variable "route_table_pod_name" {
    type = string
    default = "rt-pod-pf"
}
