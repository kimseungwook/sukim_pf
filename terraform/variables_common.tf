variable "tenancy_ocid" {
    type        = string
}
variable "user_ocid" {
    type        = string
}
variable "fingerprint" {
    type        = string
}
variable "private_key_path" {
    type        = string
}
variable "region" {
    type        = string
}
variable "compartment_ocid" {
    type        = string
}

variable "availability_domain" {
    default = "xNij:AP-SEOUL-1-AD-1"
}
variable "bb_office_ip" {
    default = "172.16.0.0/16"
}

variable "create_cost_center_tag" {
  description = "Cost Center 태그를 생성할지 여부"
  type        = bool
  default     = false
}
