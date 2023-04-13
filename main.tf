resource "google_compute_instance" "dareit-vm-ci" {
  name         = "dareit-task8-gc-vm-tf"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["dareit"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        managed_by_terraform = "true"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }
}

resource "google_storage_bucket" "static-website" {
  name          = "dareit-task8-bucket"
  location      = "US"
  force_destroy = false

  uniform_bucket_level_access = false

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
  cors {
    origin          = ["*"]
    method          = ["*"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

resource "google_storage_bucket_object" "static-website" {
  name   = "index.html"
  source = "website/index.html"
  bucket = google_storage_bucket.static-website.name
}

