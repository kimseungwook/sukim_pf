resource "oci_objectstorage_bucket" "static_website_bucket" {
  namespace           = var.namespace
  compartment_id      = var.compartment_ocid
  name                = "hyper-report-web-qa"
  storage_tier        = "Standard"
  access_type  = "ObjectRead"

  object_events_enabled = false
}

resource "oci_objectstorage_object" "hyper-report-web" {
  namespace        = var.namespace
  bucket           = oci_objectstorage_bucket.static_website_bucket.name
  object           = "index.html"
  content          = file("${path.module}/index.html")
  content_type     = "text/html"
  content_language = "en"
  content_encoding = "utf-8"
}