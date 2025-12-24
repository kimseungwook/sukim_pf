resource "oci_objectstorage_bucket" "loki_bucket" {
  namespace           = var.namespace
  compartment_id      = var.compartment_ocid
  name                = "loki-bucket-sukim"
  storage_tier        = "Standard"
  access_type  = "NoPublicAccess"

  object_events_enabled = false
}

resource "oci_objectstorage_bucket" "tempo_bucket" {
  namespace      = var.namespace
  compartment_id = var.compartment_ocid
  name           = "tempo-bucket-sukim"
  storage_tier   = "Standard"
  access_type    = "NoPublicAccess"

  object_events_enabled = false
}
resource "oci_objectstorage_bucket" "mimir_bucket" {
  namespace      = var.namespace
  compartment_id = var.compartment_ocid
  name           = "mimir-bucket-sukim"
  storage_tier   = "Standard"
  access_type    = "NoPublicAccess"

  object_events_enabled = false
}
