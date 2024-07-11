resource "google_service_account" "vm-sa" {
  account_id   = "vm-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "vm-instance" {
  name         = "vm-instance"
  machine_type = "m2-micro"
  zone         = "europe-west3"

  tags = ["tomcat", "vmka_agi"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        nazwa_maszyny = "vmka_agi"
      }
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "NVME"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}