variable "compartment_ocid" {
  description = "The OCID of the compartment where the MySQL database will be created."
  type        = string
}

variable "subnet_service_id" {
  description = "The OCID of the subnet where the MySQL database will be created."
  type        = string
}