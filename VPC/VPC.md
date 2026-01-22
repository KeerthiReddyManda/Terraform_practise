# VPCs creation 

```bash
resource "google_compute_network" "vpc" {
    for_each = var.vpcs
  name = each.key
  auto_create_subnetworks = false
}
```

# Subnets creation

```bash
resource "google_compute_subnetwork" "subnet" {
    for_each = var.vpcs

    name = each.value.subnet_name
    region = var.region
    ip_cidr_range = each.value.cidr_range
    network = google_compute_network.vpc[each.key].self_link

    depends_on = [ google_compute_network.vpc]
}
```


# Firewall creation 

```bash
resource "google_compute_firewall" "allow_ssh" {
    for_each = var.vpcs

    name = "${each.key}-allow-ssh"
    network = google_compute_network.vpc[each.key].name
    direction = "INGRESS"
    priority = 1000
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["allow-ssh"]


    allow {
        protocol = "tcp"
        ports = ["22"]
    }

    depends_on = [google_compute_network.vpc]
}
```


```bash
resource "google_compute_firewall" "allow_icmp" {
    for_each = var.vpcs

    name = "${each.key}-allow-icmp"
    network = google_compute_network.vpc[each.key].name
    direction = "INGRESS"
    priority = 1000
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["allow-icmp"]

    allow {
        protocol = "icmp"
    }
    depends_on = [google_compute_network.vpc]
}
```


#Instances creation 

```bash
resource "google_compute_instance" "vm" {
    for_each = var.vpcs

    name = "${each.key}-vm"
    machine_type = "e2-micro"
    zone = var.zone

    boot_disk {
        initialize_params {
            image = "debian-cloud/debian-12"
        }
    }
    network_interface {
        subnetwork = google_compute_subnetwork.subnet[each.key].id
        # No acces_config => no external IP (private-only)
    }

    tags = ["allow-ssh", "allow-icmp"]

    depends_on = [ google_compute_subnetwork.subnet ]
}
```

# VPC Peering 

```bash
resource "google_compute_network_peering" "vpc1_to_vpc2" {
    name = "vpc1-to-vpc2"
    network = google_compute_network.vpc["vpc1"].self_link
    peer_network = google_compute_network.vpc["vpc2"].self_link

    depends_on = [ google_compute_instance.vm ]
}

resource "google_compute_network_peering" "vpc2_to_vpc1" {
    name = "vpc2-to-vpc1"
    network = google_compute_network.vpc["vpc2"].self_link
    peer_network = google_compute_network.vpc["vpc1"].self_link

    depends_on = [ google_compute_instance.vm ]
}
```


resource "google_compute_network_peering" "vpc_peering" {
  for_each = {
   for pair in local.vpc_peering_pairs :
    "${pair.from}-to-${pair.to}" => pair
   }

 name         = each.key
 network      = google_compute_network.vpc[each.value.from].self_link
 peer_network = google_compute_network.vpc[each.value.to].self_link
}

