
terraform {
  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "eadipl"
    region                      = "ru-central1"
    key                         = "terraform.tfstate"
    skip_region_validation      = true
    skip_credentials_validation = true
  

      access_key = "YCAJEftjAEzQHtXC61PEIaD_I"
      secret_key = <key>

  }
}


