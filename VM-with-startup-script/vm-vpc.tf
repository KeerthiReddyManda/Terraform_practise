# Custom vpc

resource "google_compute_network" "vpc_with_startup" {
    name = var.vpc_name
    auto_create_subnetworks = false
}

# Custom subnet

resource "google_compute_subnetwork" "subnet_with_startup" {
    name = var.subnet_name
    region = var.region
    ip_cidr_range = var.cidr_range
    network = google_compute_network.vpc_with_startup.id
}

# Static ip reservation

resource "google_compute_address" "static_ip" {
    name = "${var.vm_name}-static-ip"
    region = var.region
}



# Custom VM

resource "google_compute_instance" "vm_with_startup" {
    name = var.vm_name
    zone = var.zone
    machine_type = var.machine_type
    tags = var.tags

    metadata_startup_script = file ("${path.module}/startup.sh")

    boot_disk {
      initialize_params {
        image = var.image
      }
    }

    network_interface {
      subnetwork = google_compute_subnetwork.subnet_with_startup.id
      access_config {
        nat_ip = google_compute_address.static_ip.address
      }
    }
}

# Firewall port 80

resource "google_compute_firewall" "allow_http" {
  name = "${var.vm_name}-allow-http"
  direction = "INGRESS"
  priority = 1000
  network = google_compute_network.vpc_with_startup.id
  source_ranges = ["0.0.0.0/0"]
  
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  
}

