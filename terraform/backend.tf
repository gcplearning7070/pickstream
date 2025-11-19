terraform {
  backend "gcs" {
    bucket = "gcp-tftbk"
    prefix = "random-names-webapp/terraform/state"
  }
}
