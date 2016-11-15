output "sys_domain" {
  value = "sys.${google_dns_managed_zone.env_dns_zone.dns_name}"
}

output "apps_domain" {
  value = "apps.${google_dns_managed_zone.env_dns_zone.dns_name}"
}

output "tcp_domain" {
  value = "tcp.${google_dns_managed_zone.env_dns_zone.dns_name}"
}

output "env_dns_zone_name_servers" {
  value = "${google_dns_managed_zone.env_dns_zone.name_servers}"
}

output "project" {
  value = "${var.project}"
}

output "region" {
  value = "${var.region}"
}

output "azs" {
  value = "${var.zones}"
}

output "service_account_key" {
  value = "${var.service_account_key}"
}

output "vm_tag" {
  value = "${var.env_name}-vms"
}

output "network_name" {
  value = "${google_compute_network.cf-network.name}"
}

output "sql_db_ip" {
  value = "${google_sql_database_instance.master.ip_address.0.ip_address}"
}

output "cf_gateway" {
  value = "${google_compute_subnetwork.cf-subnet.gateway_address}"
}

output "cf_cidr" {
  value = "${google_compute_subnetwork.cf-subnet.ip_cidr_range}"
}

output "cf_subnet" {
  value = "${google_compute_subnetwork.cf-subnet.name}"
}

output "http_lb_backend_name" {
  value = "${google_compute_backend_service.http_lb_backend_service.name}"
}

output "ws_router_pool" {
  value = "${google_compute_target_pool.cf-ws.name}"
}

output "ssh_router_pool" {
  value = "${google_compute_target_pool.cf-ssh.name}"
}

output "tcp_router_pool" {
  value = "${google_compute_target_pool.cf-tcp.name}"
}

output "buildpacks_bucket" {
  value = "${google_storage_bucket.buildpacks.name}"
}

output "droplets_bucket" {
  value = "${google_storage_bucket.droplets.name}"
}

output "packages_bucket" {
  value = "${google_storage_bucket.packages.name}"
}

output "resources_bucket" {
  value = "${google_storage_bucket.resources.name}"
}

output "cf_sql_username" {
  value = "${var.cf_sql_db_username}"
}

output "cf_sql_password" {
  value = "${var.cf_sql_db_password}"
}
