variable "compartment_ocid" {
  type = string
}

variable "vcn_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "cluster_type" {
  type = string
}

variable "cluster_nsg_id" {
  type = string
}

variable "worker_nsg_id" {
  type = string
}

variable "pod_nsg_id" {
  type = string
}

variable "subnet_public_id" {
  type = string
}

variable "subnet_oke_api_id" {
  type = string
}

variable "subnet_worker_id" {
  type = string
}



variable "cni_type" {
  type = string
}

variable "is_kubernetes_dashboard_enabled" {
  type = bool
}

variable "is_tiller_enabled" {
  type = bool
}

variable "pods_cidr" {
  type = string
}

variable "services_cidr" {
  type = string
}

variable "availability_domain" {
  type = string
}

variable "node_pools" {
  type = map(object({
    node_shape = string
    image_id = string
    boot_volume_size_in_gbs = string
    size = number
    nsg_ids = list(string)
    pod_nsg_ids = list(string)
    max_pods_per_node = number
    ocpus = number
    memory_in_gbs = number
    initial_node_labels = map(string)
    is_pv_encryption_in_transit_enabled = optional(bool, true)
  }))
}

variable "virtual_node_pools" {
  description = "Configuration for Virtual Node Pools"
  type = map(object({
    virtual_node_shape      = string
    size            = number
    node_nsg_ids    = list(string)
    pod_nsg_ids     = list(string)
    labels          = map(string)
    taint_key       = string
    taint_value     = string
    taint_effect    = string
  }))
  default = {}
}

variable "tag_namespace_name" {
  type = string

}
variable "cost_center_value" {
  type = string
}

variable "tag_namespace_description" {
  type = string
}

variable "cost_tag_name" {
  type = string
}

variable "cost_tag_description" {
  type = string
}

variable "defined_tags" {
  type = map(string)
}

variable "freeform_tags" {
  type = map(string)
}

variable "tag_namespace_id" {
  type        = string
  description = "The ID of the tag namespace"
  default     = null
}

variable "oke_pod_subnet_id" {
  type = string
}

variable "fault_domains" {
  description = "List of Fault Domains to be used for Virtual Node Pool placement"
  type        = list(string)
}
