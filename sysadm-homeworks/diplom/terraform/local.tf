locals {
  env = terraform.workspace
  standard-v3 = {
  stage = "standard-v3"
  prod = "standard-v3"
  }
  web_count_map = {
    stage = 1
    prod  = 1
  }
  count = lookup(local.web_count_map, local.env)

  name_linux-vm2 = {
    stage = "linux-vm2"
    prod  = "linux-vm2"
  }
  
  name_db01 = {
    stage = "db01"
    prod  = "db01"
  }

  name_db02 = {
    stage = "db02"
    prod  = "db02"
  }
  
  name_app = {
    stage = "app"
    prod  = "app"
  }

  name_gitlab = {
    stage = "gitlab"
    prod  = "gitlab"
  }

  name_runner = {
    stage = "runner"
    prod  = "runner"
  }
 
  name_monitoring = {
    stage = "monitoring"
    prod  = "monitoring"
  }
  
  name_nat = {
    stage = "nat"
    prod  = "nat"
  }
  
}
