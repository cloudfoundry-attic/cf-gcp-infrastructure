resource "google_sql_user" "ert" {
  name     = "${var.cf_sql_db_username}"
  password = "${var.cf_sql_db_password}"
  instance = "${google_sql_database_instance.master.name}"
  host     = "${var.cf_sql_db_host}"

  count = "${var.cf_sql_instance_count}"
}

resource "google_sql_database" "uaa" {
  name     = "uaa"
  instance = "${google_sql_database_instance.master.name}"

  count = "${var.cf_sql_instance_count}"
}

resource "google_sql_database" "ccdb" {
  name     = "ccdb"
  instance = "${google_sql_database_instance.master.name}"

  count = "${var.cf_sql_instance_count}"
}

resource "google_sql_database" "notifications" {
  name     = "notifications"
  instance = "${google_sql_database_instance.master.name}"

  count = "${var.cf_sql_instance_count}"
}

resource "google_sql_database" "autoscale" {
  name     = "autoscale"
  instance = "${google_sql_database_instance.master.name}"

  count = "${var.cf_sql_instance_count}"
}

resource "google_sql_database" "app_usage_service" {
  name     = "app_usage_service"
  instance = "${google_sql_database_instance.master.name}"

  count = "${var.cf_sql_instance_count}"
}

resource "google_sql_database" "console" {
  name     = "console"
  instance = "${google_sql_database_instance.master.name}"

  count = "${var.cf_sql_instance_count}"
}
