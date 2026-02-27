resource "oci_load_balancer_load_balancer" "sentinel_lb" {
  compartment_id = var.compartment_id
  display_name   = "sentinel_load_balancer"
  shape          = "100Mbps" # Fixed or Flexible shape
  subnet_ids     = [var.public_subnet_id]
  is_private     = false
}

resource "oci_load_balancer_backend_set" "sentinel_bes" {
  load_balancer_id = oci_load_balancer_load_balancer.sentinel_lb.id
  name             = "sentinel_backend_set"
  policy           = "ROUND_ROBIN" # Traffic distribution logic

  health_checker {
    protocol = "HTTP"
    port     = 80
    url_path = "/"
  }
}