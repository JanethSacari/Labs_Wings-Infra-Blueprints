# ==============================================================================
# Blueprint: OCI Virtual Cloud Network (VCN)
# Project: Wings-Infra-Blueprints
# Concept: Building a Secure Perimeter (The Digital Bunker)
# ==============================================================================

resource "oci_core_vcn" "wings_vcn" {
  dns_label      = "wingsvcn"
  cidr_block     = "10.0.0.0/16"
  compartment_id = var.compartment_id
  display_name   = "Wings_Secure_VCN"
}

resource "oci_core_internet_gateway" "wings_ig" {
  compartment_id = var.compartment_id
  display_name   = "Wings_Internet_Gateway"
  vcn_id         = oci_core_vcn.wings_vcn.id
}

resource "oci_core_subnet" "wings_public_subnet" {
  cidr_block        = "10.0.1.0/24"
  display_name      = "Wings_Public_Subnet"
  dns_label         = "public"
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.wings_vcn.id
  route_table_id    = oci_core_vcn.wings_vcn.default_route_table_id
  security_list_ids = [oci_core_vcn.wings_vcn.default_security_list_id]
}

# "Network protected. Perimeter is mine."