terraform {
  backend "gcs" {
    bucket = "gcp-tftbk2"
    prefix = "pickstream/terraform/state"
  }
}
