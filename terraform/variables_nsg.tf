variable "cluster_nsg_name" {
  type    = string
  default = "oke-cluster-nsg"
}

variable "node_nsg_name" {
  type    = string
  default = "oke-node-nsg"
}

variable "pod_nsg_name" {
  type    = string
  default = "oke-pod-nsg"
}
variable "backend_node_name" {
  type    = string
  default = "backend-node-nsg"
}
variable "backend_node_portal_name" {
  type    = string
  default = "backend-portal-node-nsg"
}
variable "frontend_node_name" {
  type    = string
  default = "frontend-node-nsg"
}
variable "ai_api_node_name" {
  type    = string
  default = "ai-api-node-nsg"
}
variable "front_system_node_nsg_name" {
  type    = string
  default = "front_system_node_nsg"
}
variable "back-system_node_nsg_name" {
  type    = string
  default = "back_system_node_nsg"
}
variable "backend_pod_name" {
  type    = string
  default = "backend-pod-nsg"
}
variable "backend_pod_portal_name" {
  type    = string
  default = "backend-portal-pod-nsg"
}
variable "frontend_pod_name" {
  type    = string
  default = "frontend-pod-nsg"
}
variable "ai_api_pod_name" {
  type    = string
  default = "ai-api-pod-nsg"
}
variable "front_system_node_name" {
  description = "Name for the front system node NSG"
  type        = string
  default     = "front-system-node-nsg"
}

variable "front_system_pod_name" {
  description = "Name for the front system pod NSG"
  type        = string
  default     = "front-system-pod-nsg"
}

variable "back_system_node_name" {
  description = "Name for the back system node NSG"
  type        = string
  default     = "back-system-node-nsg"
}

variable "back_system_pod_name" {
  description = "Name for the back system pod NSG"
  type        = string
  default     = "back-system-pod-nsg"
}

variable "vnp_gointern_be_node_name" {
  description = "Name for the GoIntern Backend Virtual Node NSG"
  type        = string
  default     = "vnp-gointern-be-node-nsg"
}

variable "vnp_gointern_be_pod_name" {
  description = "Name for the GoIntern Backend Virtual Pod NSG"
  type        = string
  default     = "vnp-gointern-be-pod-nsg"
}

variable "vnp_gointern_fe_node_name" {
  description = "Name for the GoIntern Frontend Virtual Node NSG"
  type        = string
  default     = "vnp-gointern-fe-node-nsg"
}

variable "vnp_gointern_fe_pod_name" {
  description = "Name for the GoIntern Frontend Virtual Pod NSG"
  type        = string
  default     = "vnp-gointern-fe-pod-nsg"
}

variable "vnp_ai_api_node_name" {
  description = "Name for the AI API Virtual Node NSG"
  type        = string
  default     = "vnp-ai-api-node-nsg"
}

variable "vnp_ai_api_pod_name" {
  description = "Name for the AI API Virtual Pod NSG"
  type        = string
  default     = "vnp-ai-api-pod-nsg"
}

variable "vnp_aify_be_node_name" {
  description = "Name for the Aify Backend Virtual Node NSG"
  type        = string
  default     = "vnp-aify-be-node-nsg"
}

variable "vnp_aify_be_pod_name" {
  description = "Name for the Aify Backend Virtual Pod NSG"
  type        = string
  default     = "vnp-aify-be-pod-nsg"
}

variable "vnp_aify_fe_node_name" {
  description = "Name for the Aify Frontend Virtual Node NSG"
  type        = string
  default     = "vnp-aify-fe-node-nsg"
}

variable "vnp_aify_fe_pod_name" {
  description = "Name for the Aify Frontend Virtual Pod NSG"
  type        = string
  default     = "vnp-aify-fe-pod-nsg"
}