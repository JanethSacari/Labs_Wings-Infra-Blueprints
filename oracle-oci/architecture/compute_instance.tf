# ==============================================================================
# Blueprint: OCI Compute Instance (The Vessel)
# Concept: Deploying a Resilient Workload
# ==============================================================================

resource "oci_core_instance" "wings_vessel" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  display_name        = "Wings_Vessel_RHEL"
  shape               = "VM.Standard.A1.Flex" # Processador Ampere

  shape_config {
    memory_in_gbs = 6
    ocpus         = 1
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.wings_public_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "wings-vessel"
  }

  source_details {
    source_type = "image"
    source_id   = var.rhel_image_id # Here you apply Red Hat Enterprise Linux
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}

# "The vessel is launched. Readiness probes active."