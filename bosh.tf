// Static IP for the BOSH director
resource "google_compute_address" "bosh" {
  name = "${var.env_name}-bosh-address"
  project = "${var.project}"
  region = "${var.region}"
}

// Allow ssh & mbus access to director
resource "google_compute_firewall" "bosh" {
  name    = "${var.env_name}-bosh"
  network = "${google_compute_network.cf-network.name}"

  allow {
    protocol = "tcp"
    ports = ["22", "6868", "25555"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["${var.env_name}-bosh"]
}
