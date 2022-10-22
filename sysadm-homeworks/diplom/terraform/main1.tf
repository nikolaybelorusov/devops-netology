
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token = "${var.yandex_token}"
  zone = "ru-central1-a"
  cloud_id  = "b1g27t6hv7qt7slm8ejk"
  folder_id = "b1ga81vfq5alsqpucip5"  
}


resource "yandex_compute_instance" "vm-2" {
  name        =  local.name_linux-vm2[terraform.workspace]
  hostname    =  local.name_linux-vm2[terraform.workspace]
  platform_id = local.standard-v3[terraform.workspace]
  zone        = "ru-central1-a"
  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }
  boot_disk {
    initialize_params {
      image_id = "fd8kdq6d0p8sij7h5qe3"

    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.default.id
#    subnet_id = "e9bcnl5vujtcsrffqt1t"
    nat = true
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }
}
############### MYSQL
resource "yandex_compute_instance" "db01" {
  name        = local.name_db01[terraform.workspace]
  hostname    = local.name_db01[terraform.workspace]
  platform_id = local.standard-v3[terraform.workspace]
  zone        = "ru-central1-a"
  resources {
    cores  = 4
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd8kdq6d0p8sij7h5qe3"
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.default.id
    #subnet_id = "e9bcnl5vujtcsrffqt1t"
  }
  metadata = {
    user-data = "${file("meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }
}
resource "yandex_compute_instance" "db02" {
  name        = local.name_db02[terraform.workspace]
  hostname    = local.name_db02[terraform.workspace]
  platform_id = local.standard-v3[terraform.workspace]
  zone        = "ru-central1-a"
  resources {
    cores  = 4
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd8kdq6d0p8sij7h5qe3"
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.default.id
    #subnet_id = "e9bcnl5vujtcsrffqt1t"
  }
  metadata = {
    user-data = "${file("meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }

}
#############app
resource "yandex_compute_instance" "app" {
  name        = local.name_app[terraform.workspace]
  hostname    = local.name_app[terraform.workspace]
  platform_id = local.standard-v3[terraform.workspace]
  zone        = "ru-central1-a"
  resources {
    cores  = 4
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd8lur056bsfs83gfnvm"
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.default.id
    #subnet_id = "e9bcnl5vujtcsrffqt1t"
  }
  metadata = {
    user-data = "${file("meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }

}

###############gitlab
resource "yandex_compute_instance" "gitlab" {
  name        = local.name_gitlab[terraform.workspace]
  hostname    = local.name_gitlab[terraform.workspace]
  platform_id = local.standard-v3[terraform.workspace]
  zone        = "ru-central1-a"
  resources {
    cores  = 4
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd8kdq6d0p8sij7h5qe3"
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.default.id
    #subnet_id = "e9bcnl5vujtcsrffqt1t"
  }
  metadata = {
    user-data = "${file("meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }

}


###############runner
resource "yandex_compute_instance" "runner" {
  name        = local.name_runner[terraform.workspace]
  hostname    = local.name_runner[terraform.workspace]
  platform_id = local.standard-v3[terraform.workspace]
  zone        = "ru-central1-a"
  resources {
    cores  = 4
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd8kdq6d0p8sij7h5qe3"
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.default.id
    #subnet_id = "e9bcnl5vujtcsrffqt1t"
  }
  metadata = {
    user-data = "${file("meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }

}

###############monitoring
resource "yandex_compute_instance" "monitoring" {
  name        = local.name_monitoring[terraform.workspace]
  hostname    = local.name_monitoring[terraform.workspace]
  platform_id = local.standard-v3[terraform.workspace]
  zone        = "ru-central1-a"
  resources {
    cores  = 4
    memory = 4
  }
  boot_disk {
    initialize_params {
      image_id = "fd8kdq6d0p8sij7h5qe3"
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.default.id
    #subnet_id = "e9bcnl5vujtcsrffqt1t"
  }
  metadata = {
    user-data = "${file("meta.txt")}"
  }
  scheduling_policy {
    preemptible = true
  }

}



######### NAT
resource "yandex_compute_instance" "nat" {
  name        = local.name_nat[terraform.workspace]
  hostname    = local.name_nat[terraform.workspace]
  platform_id = local.standard-v3[terraform.workspace]
  zone        = "ru-central1-a"
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd8v7ru46kt3s4o5f0uo"
    }
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.default.id
    #subnet_id = "e9bcnl5vujtcsrffqt1t"
    nat = true
  }
  metadata = {
    user-data = "${file("meta.txt")}"
  }
}


#####
resource "yandex_vpc_network" "network-1" {
  name = "network-1"
}
resource "yandex_vpc_subnet" "default" {
  name           = "subnet"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.001.0/24"]
}
resource "yandex_vpc_route_table" "route-table" {
  name       = "route-table"
  network_id = yandex_vpc_network.network-1.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat.network_interface.0.ip_address
  }
}

###### DNS
resource "yandex_dns_zone" "zone1" {
  name = "eadiplzone"
  zone = "eadipl.ru."
  public = true 
}



######
resource "yandex_dns_recordset" "rs1" {
  zone_id = yandex_dns_zone.zone1.id
  name = "www.eadipl.ru."
  type = "A"
  ttl = 90
  data = [yandex_compute_instance.vm-2.network_interface[0].nat_ip_address]
}
resource "yandex_dns_recordset" "rs2" {
  zone_id = yandex_dns_zone.zone1.id
  name = "gitlab.eadipl.ru."
  type = "A"
  ttl = 90
  data = [yandex_compute_instance.vm-2.network_interface[0].nat_ip_address]
}
resource "yandex_dns_recordset" "rs3" {
  zone_id = yandex_dns_zone.zone1.id
  name = "grafana.eadipl.ru."
  type = "A"
  ttl = 90
  data = [yandex_compute_instance.vm-2.network_interface[0].nat_ip_address]
}
resource "yandex_dns_recordset" "rs4" {
  zone_id = yandex_dns_zone.zone1.id
  name = "prometheus.eadipl.ru."
  type = "A"
  ttl = 90
  data = [yandex_compute_instance.vm-2.network_interface[0].nat_ip_address]
}
resource "yandex_dns_recordset" "rs5" {
  zone_id = yandex_dns_zone.zone1.id
  name = "alertmanager.eadipl.ru."
  type = "A"
  ttl = 90
  data = [yandex_compute_instance.vm-2.network_interface[0].nat_ip_address]
}
resource "yandex_dns_recordset" "rs6" {
  zone_id = yandex_dns_zone.zone1.id
  name = "eadipl.ru."
  type = "A"
  ttl = 90
  data = [yandex_compute_instance.vm-2.network_interface[0].nat_ip_address]
}

#####Output
output "internal_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}

output "external_ip_address_vm_2" {
  value = yandex_compute_instance.vm-2.network_interface.0.nat_ip_address
}
output "internal_ip_address_db01" {
  value = yandex_compute_instance.db01.network_interface.0.ip_address
}
output "internal_ip_address_db02" {
  value = yandex_compute_instance.db02.network_interface.0.ip_address
}

output "internal_ip_address_nat" {
  value = yandex_compute_instance.nat.network_interface.0.ip_address
}

output "external_ip_address_nat" {
  value = yandex_compute_instance.nat.network_interface.0.nat_ip_address
}

output "internal_ip_address_app" {
  value = yandex_compute_instance.app.network_interface.0.ip_address
}
output "internal_ip_address_gitlab" {
  value = yandex_compute_instance.gitlab.network_interface.0.ip_address
}
output "internal_ip_address_runner" {
  value = yandex_compute_instance.runner.network_interface.0.ip_address
}

resource "local_file" "ssh_config" {
  filename = "/home/ea/.ssh/config"
  content = <<-EOT
  Host eadipl
    HostName ${yandex_compute_instance.vm-2.network_interface.0.nat_ip_address}
    User eae
    IdentityFile ~/.ssh/id_rsa

  Host db01 db01.eadipl.ru
    HostName ${yandex_compute_instance.db01.network_interface.0.ip_address}
    User eae
    IdentityFile ~/.ssh/id_rsa
      ProxyJump eae@${yandex_compute_instance.vm-2.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host db02 db02.eadipl.ru
    HostName ${yandex_compute_instance.db02.network_interface.0.ip_address}
    User eae
    IdentityFile ~/.ssh/id_rsa
      ProxyJump eae@${yandex_compute_instance.vm-2.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host app app.eadipl.ru
    HostName ${yandex_compute_instance.app.network_interface.0.ip_address}
    User eae
    IdentityFile ~/.ssh/id_rsa
      ProxyJump eae@${yandex_compute_instance.vm-2.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  
  Host gitlab gitlab.eadipl.ru
    HostName ${yandex_compute_instance.gitlab.network_interface.0.ip_address}
    User eae
    IdentityFile ~/.ssh/id_rsa
      ProxyJump eae@${yandex_compute_instance.vm-2.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host runner runner.eadipl.ru
    HostName ${yandex_compute_instance.runner.network_interface.0.ip_address}
    User eae
    IdentityFile ~/.ssh/id_rsa
      ProxyJump eae@${yandex_compute_instance.vm-2.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host mon monitoring.eadipl.ru
    HostName ${yandex_compute_instance.monitoring.network_interface.0.ip_address}
    User eae
    IdentityFile ~/.ssh/id_rsa
      ProxyJump eae@${yandex_compute_instance.vm-2.network_interface.0.nat_ip_address}
      ProxyCommand ssh -W %h:%p -i .ssh/id_rsa

  Host nat
    HostName ${yandex_compute_instance.nat.network_interface.0.nat_ip_address}
    User eae
    IdentityFile ~/.ssh/id_rsa


  EOT
}

resource "local_file" "var" {
  filename = "/home/ea/eadipl/terra/group_vars/dbservers/vars.yml"
  content  = <<-EOT
  ---
  eadipl_ip_addr: "${yandex_compute_instance.vm-2.network_interface.0.nat_ip_address}"
  db01_ip_addr: "${yandex_compute_instance.db01.network_interface.0.ip_address}"
  db02_ip_addr: "${yandex_compute_instance.db02.network_interface.0.ip_address}"
  app_ip_addr: "${yandex_compute_instance.app.network_interface.0.ip_address}"
  gitlab_ip_addr: "${yandex_compute_instance.gitlab.network_interface.0.ip_address}"
  runner_ip_addr: "${yandex_compute_instance.runner.network_interface.0.ip_address}"
  monitoring_ip_addr: "${yandex_compute_instance.monitoring.network_interface.0.ip_address}"
  nat_ip_addr: "${yandex_compute_instance.nat.network_interface.0.nat_ip_address}"
  EOT
}
