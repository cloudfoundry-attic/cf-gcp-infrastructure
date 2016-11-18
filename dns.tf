resource "google_dns_managed_zone" "env_dns_zone" {
  name        = "${var.env_name}-zone"
  dns_name    = "${var.env_name}.${var.dns_suffix}."
  description = "DNS zone for the ${var.env_name} environment"
}

resource "google_dns_record_set" "wildcard-sys-dns" {
  name       = "*.sys.${google_dns_managed_zone.env_dns_zone.dns_name}"
  depends_on = ["google_compute_global_address.cf"]
  type       = "A"
  ttl        = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${google_compute_global_address.cf.address}"]
}

resource "google_dns_record_set" "doppler-sys-dns" {
  name       = "doppler.sys.${google_dns_managed_zone.env_dns_zone.dns_name}"
  depends_on = ["google_compute_address.cf-ws"]
  type       = "A"
  ttl        = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${google_compute_address.cf-ws.address}"]
}

resource "google_dns_record_set" "loggregator-sys-dns" {
  name       = "loggregator.sys.${google_dns_managed_zone.env_dns_zone.dns_name}"
  depends_on = ["google_compute_address.cf-ws"]
  type       = "A"
  ttl        = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${google_compute_address.cf-ws.address}"]
}

resource "google_dns_record_set" "wildcard-apps-dns" {
  name       = "*.apps.${google_dns_managed_zone.env_dns_zone.dns_name}"
  depends_on = ["google_compute_global_address.cf"]
  type       = "A"
  ttl        = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${google_compute_global_address.cf.address}"]
}

resource "google_dns_record_set" "app-ssh-dns" {
  name       = "ssh.sys.${google_dns_managed_zone.env_dns_zone.dns_name}"
  depends_on = ["google_compute_address.cf-ssh"]
  type       = "A"
  ttl        = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${google_compute_address.cf-ssh.address}"]
}

resource "google_dns_record_set" "bosh-dns" {
  name       = "bosh.${google_dns_managed_zone.env_dns_zone.dns_name}"
  depends_on = ["google_compute_address.bosh.address"]
  type       = "A"
  ttl        = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${google_compute_address.bosh.address}"]
}

resource "google_dns_record_set" "tcp-dns" {
  name       = "tcp.${google_dns_managed_zone.env_dns_zone.dns_name}"
  depends_on = ["google_compute_address.cf-tcp"]
  type       = "A"
  ttl        = 300

  managed_zone = "${google_dns_managed_zone.env_dns_zone.name}"

  rrdatas = ["${google_compute_address.cf-tcp.address}"]
}
