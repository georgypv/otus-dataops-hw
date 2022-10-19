#### PRODIVER INFO #####

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}


provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

########################


#### VM ################
resource "yandex_compute_instance" "vm-1" {
  name = "my-vm-1"

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd8h059qvtg37ks9ke9o"
    }
  }


  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/yandex_cloud.pub")}"
  }

  scheduling_policy {
    preemptible = true
  }

}
#########################


### NETWORK #############
resource "yandex_vpc_network" "network-1" {
  name = "my-network-1"
}
#########################

### SUBNET ##############
resource "yandex_vpc_subnet" "subnet-1" {
  name           = "my-subnet-1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]

}
