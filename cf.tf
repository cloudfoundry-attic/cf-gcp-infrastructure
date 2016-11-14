// Allow access to Cloud Foundry router
resource "google_compute_firewall" "cf-router" {
  name    = "cf-router"
  network = "${google_compute_network.network.name}"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "4443"]
  }

  target_tags = ["cf-router"]
}

// Allow access to Diego ssh-proxy
resource "google_compute_firewall" "diego-ssh" {
  name    = "diego-ssh"
  network = "${google_compute_network.network.name}"

  allow {
    protocol = "tcp"
    ports    = ["2222"]
  }

  target_tags = ["diego-ssh"]
}

// Static IP address for forwarding rule
resource "google_compute_address" "cf" {
  name = "cf"
}

// Static IP address for diego ssh
resource "google_compute_address" "diego-ssh" {
  name = "diego-ssh"
}

// Load balancing target pool
resource "google_compute_target_pool" "cf-router" {
  name = "cf-router"
}

// Load balancing target pool
resource "google_compute_target_pool" "diego-ssh" {
  name = "diego-ssh"
}

// HTTP forwarding rule
resource "google_compute_forwarding_rule" "cf-http" {
  name        = "cf-http"
  target      = "${google_compute_target_pool.cf-router.self_link}"
  port_range  = "80"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf.address}"
}

// HTTPS forwarding rule
resource "google_compute_forwarding_rule" "cf-https" {
  name        = "cf-https"
  target      = "${google_compute_target_pool.cf-router.self_link}"
  port_range  = "443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf.address}"
}

// SSH forwarding rule
resource "google_compute_forwarding_rule" "diego-ssh" {
  name        = "cf-ssh"
  target      = "${google_compute_target_pool.diego-ssh.self_link}"
  port_range  = "2222"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.diego-ssh.address}"
}

// WSS forwarding rule
resource "google_compute_forwarding_rule" "cf-wss" {
  name        = "cf-wss"
  target      = "${google_compute_target_pool.cf-router.self_link}"
  port_range  = "4443"
  ip_protocol = "TCP"
  ip_address  = "${google_compute_address.cf.address}"
}
