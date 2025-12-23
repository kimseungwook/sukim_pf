variable "tag_namespace_name" {
  type        = string
  description = "Name for the tag namespace"
  default     = "GoyoaiWebOKE"
}

variable "cost_center_value" {
  type        = string
  description = "Value for the CostCenter tag"
  default     = "33"
}

variable "tag_namespace_id" {
  type        = string
  description = "OCID of the existing Tag Namespace (to bypass lookup failures)"
  default     = null
}