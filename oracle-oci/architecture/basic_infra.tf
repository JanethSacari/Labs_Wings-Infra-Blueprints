# 1. Provider Configuration
provider "oci" {
  region = "us-ashburn-1" 
}

# 2. Virtual Cloud Network (VCN) Resource
resource "oci_core_vcn" "internal_network_vcn" {
  # Private IP range according to RFC 1918
  cidr_block     = "10.0.0.0/16"
  compartment_id = "ocid1.compartment.oc1..your_compartment_id"
  display_name   = "production_network_vcn"
  dns_label      = "prodvcn"
}

# 3. Public Subnet Resource
resource "oci_core_subnet" "frontend_subnet" {
  cidr_block        = "10.0.1.0/24"
  display_name      = "frontend_public_subnet"
  compartment_id    = "ocid1.compartment.oc1..your_compartment_id"
  vcn_id            = oci_core_vcn.internal_network_vcn.id
  dns_label         = "frontendsn"
  
  # Set to false to allow Public IPs on instances
  prohibit_public_ip_on_vnic = false
}