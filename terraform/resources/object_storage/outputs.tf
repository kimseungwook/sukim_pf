output "loki_bucket_name" {
  value = oci_objectstorage_bucket.loki_bucket.name
}

output "loki_bucket_id" {
  value = oci_objectstorage_bucket.loki_bucket.bucket_id
}
