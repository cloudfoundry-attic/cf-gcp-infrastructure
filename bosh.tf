resource "google_compute_network" "network" {
  name = "${var.env_name}"
}

// Static IP for the BOSH director
resource "google_compute_address" {
  name = "${var.env_name}-director-address"
  project = "${var.projectid}"
  region = "${var.region}"
}

// Subnet for the BOSH director
resource "google_compute_subnetwork" {
  name          = "${var.env_name}-${var.region}"
  ip_cidr_range = "10.0.0.0/16"
  network       = "${google_compute_network.network.self_link}"
}

// Allow open access between internal VMs
resource "google_compute_firewall" {
  name    = "${var.env_name}-internal"
  network = "${google_compute_network.network.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
  }

  allow {
    protocol = "udp"
  }
  target_tags = ["${var.env_name}-internal"]
  source_tags = ["${var.env_name}-internal"]
}


// Allow ssh & mbus access to director
resource "google_compute_firewall" {
  name    = "${var.env_name}-bosh-ssh"
  network = "${google_compute_network.network.name}"

  allow {
    protocol = "tcp"
    ports = ["22", "6868", "25555"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["${var.env_name}-bosh-ssh"]
}
