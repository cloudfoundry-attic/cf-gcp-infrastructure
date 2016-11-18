resource "google_compute_network" "cf-network" {
  name = "cf-network"
}

resource "google_compute_subnetwork" "cf-subnet" {
  name          = "cf-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = "${google_compute_network.cf-network.self_link}"
  region        = "${var.region}"
}
