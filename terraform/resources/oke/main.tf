resource "oci_identity_tag_namespace" "goyoai_web_oke_namespace" {
  count          = var.tag_namespace_id == null ? 1 : 0
  compartment_id = var.compartment_ocid
  name           = var.tag_namespace_name
  description    = "Tag namespace for Goyoai Web OKE resources"
}

resource "oci_identity_tag" "cost_center_tag" {
  count            = var.tag_namespace_id == null ? 1 : 0
  tag_namespace_id = var.tag_namespace_id != null ? var.tag_namespace_id : oci_identity_tag_namespace.goyoai_web_oke_namespace[0].id
  name             = "CostCenter"
  description      = "Cost Center tag"
}

resource "oci_containerengine_cluster" "oke_cluster" {
  compartment_id     = var.compartment_ocid
  kubernetes_version = var.kubernetes_version
  name               = var.cluster_name
  vcn_id             = var.vcn_id
  type               = var.cluster_type

  endpoint_config {
    nsg_ids    = [var.cluster_nsg_id]
    subnet_id  = var.subnet_oke_api_id
  }

  cluster_pod_network_options {
    cni_type = var.cni_type
  }

  options {
    add_ons {
      is_kubernetes_dashboard_enabled = var.is_kubernetes_dashboard_enabled
      is_tiller_enabled               = var.is_tiller_enabled
    }
    service_lb_subnet_ids = [var.subnet_public_id]
    kubernetes_network_config {
      pods_cidr     = var.pods_cidr
      services_cidr = var.services_cidr
    }
    service_lb_config {
      defined_tags = var.defined_tags
      freeform_tags = var.freeform_tags
    }
  }

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags  
}

resource "oci_containerengine_node_pool" "node_pool" {
  for_each = var.node_pools

  cluster_id         = oci_containerengine_cluster.oke_cluster.id
  compartment_id     = var.compartment_ocid
  kubernetes_version = var.kubernetes_version
  name               = each.key
  node_shape         = each.value.node_shape

  node_source_details {
    image_id    = each.value.image_id
    source_type = "IMAGE"
    boot_volume_size_in_gbs = each.value.boot_volume_size_in_gbs
  }

  node_config_details {
    size                             = each.value.size
    is_pv_encryption_in_transit_enabled =  lookup(each.value, "is_pv_encryption_in_transit_enabled", true)
    nsg_ids                          = each.value.nsg_ids
    
    placement_configs {
      availability_domain = var.availability_domain
      subnet_id           = var.subnet_worker_id
    }

    node_pool_pod_network_option_details {
      cni_type         = var.cni_type
      pod_nsg_ids      = each.value.pod_nsg_ids
      max_pods_per_node = each.value.max_pods_per_node
      pod_subnet_ids   = [var.oke_pod_subnet_id]
    }
  }

  node_shape_config {
    ocpus         = each.value.ocpus
    memory_in_gbs = each.value.memory_in_gbs
  }

  dynamic "initial_node_labels" {
    for_each = each.value.initial_node_labels
    content {
      key   = initial_node_labels.key
      value = initial_node_labels.value
    }
  }

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags

  node_pool_cycling_details {
    is_node_cycling_enabled = true
    maximum_surge           = 1
    maximum_unavailable     = 0
  }
}

# Virtual Node Pools
resource "oci_containerengine_virtual_node_pool" "virtual_node_pool" {
  for_each = var.virtual_node_pools
  
  cluster_id     = oci_containerengine_cluster.oke_cluster.id
  compartment_id = var.compartment_ocid
  display_name   = each.key

  
  placement_configurations {
    availability_domain = var.availability_domain
    fault_domain        = var.fault_domains
    subnet_id           = var.subnet_worker_id
  }
  
  pod_configuration {
    subnet_id  = var.oke_pod_subnet_id
    nsg_ids    = each.value.pod_nsg_ids
    shape = each.value.virtual_node_shape
  }
  
  size    = each.value.size
  nsg_ids = each.value.node_nsg_ids
  
  # Labels
  dynamic "initial_virtual_node_labels" {
    for_each = each.value.labels
    
    content {
      key   = initial_virtual_node_labels.key
      value = initial_virtual_node_labels.value
    }
  }
  
  # Taints
  taints {
    key    = each.value.taint_key
    value  = each.value.taint_value
    effect = each.value.taint_effect
  }
  
  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}