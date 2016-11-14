provider "google" {
    project = "${var.projectid}"
    region = "${var.region}"
    credentials = "${var.service_account_key}"
}

