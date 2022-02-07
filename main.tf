terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.70.0"
    }
  }
}

provider "yandex" {
  token     = "AQAAAABc92bvAATuwR8yoKyMGkhwqUjs_o11cn0"
  cloud_id  = "b1g8qt41tj2u2ts23n3v"
  folder_id = "b1gk46nap2lt3rdlg4mf"
  zone      = "ru-central1-a"
}

locals {
  folder_id = "b1gk46nap2lt3rdlg4mf"
}

// Создание сервис аккаунта terraform
resource "yandex_iam_service_account" "sa" {
  folder_id = local.folder_id
  name      = "terraform"
}

// Назначение роли
resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
  folder_id = local.folder_id
  role      = "admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Создание сети и подсети
resource "yandex_vpc_network" "network" {
  name = "diplom"
}
resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  description    = "NAT instance"
  network_id     = yandex_vpc_network.network.id
}
 resource "yandex_vpc_subnet" "private-subnet1" {
  name           = "private1"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-a"
  description    = "Private instance"
  network_id     = yandex_vpc_network.network.id
}
 resource "yandex_vpc_subnet" "private-subnet2" {
  name           = "private2"
  v4_cidr_blocks = ["192.168.30.0/24"]
  zone           = "ru-central1-a"
  description    = "Private instance"
  network_id     = yandex_vpc_network.network.id
}
resource "yandex_vpc_subnet" "private-subnet3" {
  name           = "private3"
  v4_cidr_blocks = ["192.168.40.0/24"]
  zone           = "ru-central1-a"
  description    = "Private instance"
  network_id     = yandex_vpc_network.network.id
}

// Создание виртуальных машин
resource "yandex_compute_instance" "master" {
  name        = "master"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  
  resources {
    core_fraction = 20
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8mfc6omiki5govl68h"
      size = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public-subnet.id
    nat       = true
    ip_address = "192.168.10.10"
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }

}

resource "yandex_compute_instance" "worker1" {
  name        = "worker1"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  
  resources {
    core_fraction = 5
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8mfc6omiki5govl68h"
      size = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet1.id
    nat       = true
    ip_address = "192.168.20.20"
  }

  metadata = {
     ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
 }

resource "yandex_compute_instance" "worker2" {
  name        = "worker2"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  
  resources {
    core_fraction = 5
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8mfc6omiki5govl68h"
      size = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet2.id
    nat       = true
    ip_address = "192.168.30.30"
  }

  metadata = {
     ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
 }

resource "yandex_compute_instance" "worker3" {
  name        = "worker3"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  
  resources {
    core_fraction = 5
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8mfc6omiki5govl68h"
      size = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private-subnet3.id
    nat       = true
    ip_address = "192.168.40.40"
  }

  metadata = {
     ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
 }







