# Storage Bucket and Data
resource "google_storage_bucket" "input_bucket" {
  name     = "${var.project_id}-input"
  location = var.region
}

resource "google_storage_bucket_object" "data_1" {
  name   = var.data_1_name
  source = var.data_1_path
  bucket = google_storage_bucket.input_bucket.name
}

resource "google_storage_bucket_object" "data_2" {
  name   = var.data_2_name
  source = var.data_2_path
  bucket = google_storage_bucket.input_bucket.name
}

resource "google_storage_bucket_object" "data_3" {
  name   = var.data_3_name
  source = var.data_3_path
  bucket = google_storage_bucket.input_bucket.name
}

# DB
resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "sql_instance" {
  name              = "${var.instance_name}-${random_id.db_name_suffix.hex}"
  database_version  = var.database_version
  region            = var.region

  settings {
    tier      = var.instance_tier
    disk_size = var.disk_space

    location_preference {
      zone = var.location
    }

    ip_configuration {
      authorized_networks {
        value           = "0.0.0.0/0"
        name            = "test-cluster"
      }
    }
  }

  deletion_protection = "false"
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.sql_instance.name
//  instance = var.instance_name
}

resource "google_sql_user" "users" {
  name     = var.db_username
  instance = google_sql_database_instance.sql_instance.name
//  instance = var.instance_name
  host     = "*"
  password = var.db_password
}