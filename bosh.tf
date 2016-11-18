// Static IP for the BOSH director
resource "google_compute_address" "bosh" {
  name = "bosh"
  project = "${var.project}"
  region = "${var.region}"
}

// Allow ssh & mbus access to director
resource "google_compute_firewall" "bosh" {
  name    = "bosh"
  network = "${google_compute_network.cf-network.name}"

  allow {
    protocol = "tcp"
    ports = ["22", "6868", "25555"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["bosh"]
}
