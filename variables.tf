variable "project" {
  type = "string"
}

variable "env_name" {
  type = "string"
}

variable "region" {
  type = "string"
  default = "us-central1"
  description = "Configuring will result in the mismatch of assumptions with cf-deployment"
}

variable "zones" {
  type = "list"
  default = ["us-central1-a", "us-central1-b", "us-central1-c"]
  description = "Configuring will result in the mismatch of assumptions with cf-deployment"
}

variable "service_account_key" {
  type = "string"
}

variable "dns_suffix" {
  type = "string"
}

variable "ssl_cert" {
  type        = "string"
  description = "ssl certificate content"
}

variable "ssl_cert_private_key" {
  type        = "string"
  description = "ssl certificate private key content"
}

/***********************
 * Optional CF Config *
 ***********************/

/* You can opt in to create a Google SQL Database Instance, Database, and User for CF.
By default we have `cf_sql_instance_count` set to `0` but setting it to `1` will create them. */

variable "sql_db_tier" {
  type    = "string"
  default = "db-f1-micro"
}

variable "cf_sql_instance_count" {
  type        = "string"
  default     = "0"
  description = "Optional configuration of a Google SQL Database Instance, Database, and User."
}

variable "cf_sql_db_host" {
  type    = "string"
  default = ""
}

variable "cf_sql_db_username" {
  type    = "string"
  default = ""
}

variable "cf_sql_db_password" {
  type    = "string"
  default = ""
}
