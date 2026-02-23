# Provider Config for OCI
provider "oci" {
  tenancy_ocid     = "ocid1.tenancy.oc1..." 
  user_ocid        = "ocid1.user.oc1..."
  fingerprint      = "...somekey..."
  private_key_path = "~/.oci/oci_api_key.pem"
  region           = "us-ashburn-1"
}