terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"

    }
  }

 backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "terraform-object"
    region     = "us-east-1"
    key        = "mnt/hgfs/Diplom/ya/terraform.tfstate"
    access_key = "LSVoHA6ODhYSQfPZd1GU"
    secret_key = "HPvWlC-paKwVhUEPwzy1C24NvhGNe1NdH2NDS_Cl"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     = "AQAAAABc5PvKAATuwcahliVymEgIibAj27msSvs"
  cloud_id  = "b1gie36vbchrk9je19j3"
  folder_id = "b1ggj97b2ktqrl7rkcau"
  zone      = "ru-central1-a"
}

locals {
  folder_id = "b1ggj97b2ktqrl7rkcau"
}

// Создание сервис аккаунта kubernetes
resource "yandex_iam_service_account" "sa" {
  folder_id = local.folder_id
  name      = "kub"
 }

// Назначение роли
resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
  folder_id = local.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Создание сети и подсети
resource "yandex_vpc_network" "network" {
  name = "diplom"
}
resource "yandex_vpc_subnet" "subnet-kube-a" {
  name           = "private-kube-a"
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  description    = "Private instance"
  network_id     = yandex_vpc_network.network.id
}
resource "yandex_vpc_subnet" "subnet-kube-b" {
  name           = "private-kube-b"
  v4_cidr_blocks = ["192.168.20.0/24"]
  zone           = "ru-central1-b"
  description    = "Private instance"
  network_id     = yandex_vpc_network.network.id
}
resource "yandex_vpc_subnet" "subnet-kube-c" {
  name           = "private-kube-c"
  v4_cidr_blocks = ["192.168.30.0/24"]
  zone           = "ru-central1-c"
  description    = "Private instance"
  network_id     = yandex_vpc_network.network.id
}

// Создание регионального мастера kubernetes
resource "yandex_kubernetes_cluster" "regional_cluster_resource_kuber" {
  name        = "my-kuber"
  description = "regional cluster"

  network_id = yandex_vpc_network.network.id

  master {
    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.subnet-kube-a.zone
        subnet_id = yandex_vpc_subnet.subnet-kube-a.id
      }

      location {
        zone      = yandex_vpc_subnet.subnet-kube-b.zone
        subnet_id = yandex_vpc_subnet.subnet-kube-b.id
      }

      location {
        zone      = yandex_vpc_subnet.subnet-kube-c.zone
        subnet_id = yandex_vpc_subnet.subnet-kube-c.id
      }
    }

    version   = "1.20"
    public_ip = true

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        day        = "monday"
        start_time = "15:00"
        duration   = "3h"
      }
    }
  }

  service_account_id      = yandex_iam_service_account.sa.id
  node_service_account_id = yandex_iam_service_account.sa.id

  labels = {
    my_key       = "value"
    my_other_key = "other_value"
  }

  release_channel = "STABLE"
}

// Создание группы узлов
resource "yandex_kubernetes_node_group" "my_node_group" {
  cluster_id  = yandex_kubernetes_cluster.regional_cluster_resource_kuber.id
  name        = "kube-group"
  description = "description"
  version     = "1.20"

  labels = {
    "key" = "value"
  }

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat                = true
      subnet_ids         = ["${yandex_vpc_subnet.subnet-kube-a.id}"]
    }
    resources {
      memory = 2
      cores  = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 30
    }

    scheduling_policy {
      preemptible = true
    }
  }

  scale_policy {
    auto_scale {
      min     = 2
      max     = 3
      initial = 3
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"

    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    }
  }
