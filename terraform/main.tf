# data "oci_identity_tag_namespaces" "sukim_oke_namespace" {
#   compartment_id = var.compartment_ocid
#   filter {
#     name   = "name"
#     values = [var.tag_namespace_name]
#   }
# }



# OKE Node Pool Options - Get valid OKE images
data "oci_containerengine_node_pool_option" "oke_node_pool_options" {
  node_pool_option_id = "all"
  compartment_id      = var.compartment_ocid
}

# Dynamic Image Lookup (Reliable Method)
locals {
  # Find LATEST valid image for ARM (A1.Flex)
  # Look for "aarch64" and "OKE" in the source name
  oke_arm_images = [
    for img in data.oci_containerengine_node_pool_option.oke_node_pool_options.sources :
    img.image_id if length(regexall("aarch64", img.source_name)) > 0 && length(regexall("OKE", img.source_name)) > 0
  ]

  # Find LATEST valid image for AMD (E3/E4/E5)
  # Look for "x86_64" and "OKE" in the source name
  oke_amd_images = [
    for img in data.oci_containerengine_node_pool_option.oke_node_pool_options.sources :
    img.image_id if length(regexall("x86_64", img.source_name)) > 0 && length(regexall("OKE", img.source_name)) > 0
  ]
  
  # Fallback IDs (Official OKE images for ap-seoul-1)
  fallback_arm_image_id = "ocid1.image.oc1.ap-seoul-1.aaaaaaaabnw26mt4gt6ix5vl5mwx5qvec2ys76qix5frgvypqcdfk6n3yzwa"
  fallback_amd_image_id = "ocid1.image.oc1.ap-seoul-1.aaaaaaaaluk35pbjgpvhwquqfmdhkyxf5xj4aa2pqbbpwcmzhk5a5k5afrta"

  # Select the first one (Latest) or Fallback
  oke_arm_image_id = length(local.oke_arm_images) > 0 ? local.oke_arm_images[0] : local.fallback_arm_image_id
  oke_amd_image_id = length(local.oke_amd_images) > 0 ? local.oke_amd_images[0] : local.fallback_amd_image_id
}

locals {
  tag_namespace_id = var.tag_namespace_id
  tag_namespace_name = var.tag_namespace_name
}

resource "oci_identity_tag" "cost_center_tag" {
  count            = var.create_cost_center_tag && local.tag_namespace_id != null ? 1 : 0
  tag_namespace_id = local.tag_namespace_id
  name             = "CostCenter"
  description      = "Cost Center tag"
}

module "vcn" {
  source             = "./resources/vcn"
  compartment_ocid   = var.compartment_ocid
  primary_vcn_cidr   = var.primary_vcn_cidr
  
  vcn_name           = var.vcn_name
  vcn_dns_label      = var.vcn_dns_label

  # Subnets
  subnet_public_cidr       = var.subnet_public_cidr
  subnet_public_name       = var.subnet_public_name
  subnet_public_dns_label  = var.subnet_public_dns_label
  
  subnet_oke_api_cidr      = var.subnet_oke_api_cidr
  subnet_oke_api_name      = var.subnet_oke_api_name
  subnet_oke_api_dns_label = var.subnet_oke_api_dns_label

  subnet_worker_cidr       = var.subnet_worker_cidr
  subnet_worker_name       = var.subnet_worker_name
  subnet_worker_dns_label  = var.subnet_worker_dns_label

  subnet_pod_cidr          = var.subnet_pod_cidr
  subnet_pod_name          = var.subnet_pod_name
  subnet_pod_dns_label     = var.subnet_pod_dns_label

  # Security Lists (from Security List Module)
  public_sl_id      = module.security_list.public_security_list_id
  oke_api_sl_id     = module.security_list.oke_api_security_list_id
  worker_sl_id      = module.security_list.worker_security_list_id
  pod_sl_id         = module.security_list.pod_security_list_id

  # Gateways
  internet_gateway_name = var.internet_gateway_name
  nat_gateway_name      = var.nat_gateway_name
  service_gateway_name  = var.service_gateway_name
  drg_name              = var.drg_name
  drg_attachment_name   = var.drg_attachment_name
  cpe_name              = var.cpe_name
  cpe_ip                = var.cpe_ip
  
  # Route Tables
  route_table_public_name      = var.route_table_public_name
  route_table_oke_api_name     = var.route_table_oke_api_name
  route_table_worker_name      = var.route_table_worker_name
  route_table_pod_name         = var.route_table_pod_name
}

module "security_list" {
  source = "./resources/security_list"
  compartment_ocid = var.compartment_ocid
  vcn_id           = module.vcn.vcn_id
  vcn_cidr         = module.vcn.vcn_cidr_block
  
  subnet_pod_cidr_block = var.subnet_pod_cidr
}

module "nsg" {
  source = "./resources/nsg"
  compartment_ocid = var.compartment_ocid
  vcn_id           = module.vcn.vcn_id
  vcn_cidr         = module.vcn.vcn_cidr_block
  subnet_pod_cidr_block = var.subnet_pod_cidr
}

module "oke" {
  source = "./resources/oke"

  compartment_ocid   = var.compartment_ocid
  vcn_id             = module.vcn.vcn_id
  cluster_name       = "sukim-web-prd"
  kubernetes_version = "v1.34.1"
  cluster_type       = "ENHANCED_CLUSTER"
  cluster_nsg_id     = module.nsg.cluster_nsg_id
  worker_nsg_id      = module.nsg.worker_nsg_id
  pod_nsg_id         = module.nsg.pod_nsg_id
  subnet_public_id   = module.vcn.subnet_public_id
  subnet_oke_api_id  = module.vcn.subnet_oke_api_id
  subnet_worker_id   = module.vcn.subnet_worker_id
  oke_pod_subnet_id  = module.vcn.subnet_pod_id
  cni_type           = "OCI_VCN_IP_NATIVE"
  
  is_kubernetes_dashboard_enabled = true
  is_tiller_enabled               = false
  pods_cidr                       = module.vcn.subnet_pod_cidr
  services_cidr                   = "10.96.0.0/16"
  availability_domain             = var.availability_domain
  fault_domains                   = ["FAULT-DOMAIN-1", "FAULT-DOMAIN-2", "FAULT-DOMAIN-3"]

  node_pools = {
    "arm64-tools" = {
      node_shape              = "VM.Standard.A1.Flex"
      image_id                = local.oke_arm_image_id
      boot_volume_size_in_gbs = "50"
      size                    = 1
      nsg_ids                 = [module.nsg.worker_nsg_id]
      pod_nsg_ids             = [module.nsg.pod_nsg_id]
      max_pods_per_node       = 91
      ocpus                   = 4
      memory_in_gbs           = 24
      is_pv_encryption_in_transit_enabled = false
      initial_node_labels     = {
        "service"  = "tools"
        "cpu-type" = "arm64"
      }
    },
    "sukim-web-monitoring" = {
      node_shape              = "VM.Standard.A1.Flex"
      image_id                = local.oke_arm_image_id
      boot_volume_size_in_gbs = "50"
      size                    = 1
      nsg_ids                 = [module.nsg.worker_nsg_id]
      pod_nsg_ids             = [module.nsg.pod_nsg_id]
      max_pods_per_node       = 62
      ocpus                   = 6
      memory_in_gbs           = 32
      is_pv_encryption_in_transit_enabled = false
      initial_node_labels     = { 
        "service" = "monitoring"
        "cpu-type" = "arm64"
      }
    },
    "amd64-tools" = {
      node_shape              = "VM.Standard.E5.Flex"
      image_id                = local.oke_amd_image_id
      boot_volume_size_in_gbs = "50"
      size                    = 1
      nsg_ids                 = [module.nsg.worker_nsg_id]
      pod_nsg_ids             = [module.nsg.pod_nsg_id]
      max_pods_per_node       = 31
      ocpus                   = 1
      memory_in_gbs           = 8
      is_pv_encryption_in_transit_enabled = false
      initial_node_labels     = {
        "service"  = "tools"
        "cpu-type" = "amd64"
      }
    }    
  }

# Virtual Node Pools (신규)
    virtual_node_pools = {
      "sukim-build" = {
        virtual_node_shape   = "Pod.Standard.E4.Flex"
        size         = 1
        node_nsg_ids = [module.nsg.worker_nsg_id]
        pod_nsg_ids  = [module.nsg.pod_nsg_id]
        labels = {
          "service"       = "sukim-build"
          "cpu-type"      = "amd64"
          "workload-type" = "build"
          "node-type"     = "virtual"
        }
        taint_key    = "workload"
        taint_value  = "sukim-build"
        taint_effect = "NoSchedule"
      }     
    }
  

  tag_namespace_name        = local.tag_namespace_name
  tag_namespace_description = "Tag namespace for Goyoai Web resources"
  cost_tag_name             = "CostCenter"
  cost_tag_description      = "Environment tag"

  defined_tags  = local.tag_namespace_id != null ? {
    "${local.tag_namespace_name}.CostCenter" = var.cost_center_value
  } : {}
  freeform_tags = {"service" = "Goyoai-Web", "env" = "prd"}
  
  tag_namespace_id   = local.tag_namespace_id
  cost_center_value  = var.cost_center_value
}

module "monitoring-object-storage" {
  source = "./resources/object_storage"
  compartment_ocid = var.compartment_ocid
  namespace = "cn7ipyag4bte"
}

module "sukim-bastion" {
  source = "./resources/bastion"
  compartment_ocid = var.compartment_ocid
  subnet_service_id = module.vcn.subnet_oke_api_id # Target: OKE API Subnet for kubectl
}