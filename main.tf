terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "~> 2.26"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.7"
    }
  }
}

provider "vultr" {
  rate_limit = 700
}

resource "random_string" "vpn_psk" {
  length  = 16
  special = false
}
resource "random_string" "vpn_username" {
  length  = 8
  special = false
  upper   = false
}
resource "random_string" "vpn_password" {
  length  = 16
  special = false
}

resource "vultr_instance" "vpn" {
  plan            = "vc2-1c-1gb" # $5.00/month plan
  region          = var.region   # Using the region variable
  os_id           = 1743         # Ubuntu 22.04
  label           = "vpn-server"
  hostname        = "vpn-server"
  enable_ipv6     = true
  backups         = "disabled"
  ddos_protection = false
  user_data = templatefile("${path.module}/cloud-init.yml", {
    vpn_psk      = random_string.vpn_psk.result
    vpn_username = random_string.vpn_username.result
    vpn_password = random_string.vpn_password.result
  })
}

resource "null_resource" "wait_for_setup" {
  depends_on = [vultr_instance.vpn]

  provisioner "local-exec" {
    command = <<-EOT
      echo "Waiting for 6 minutes for VPN setup to complete..."
      sleep 360
      echo "Setup time completed!"
    EOT
  }
}

output "notice" {
  value      = "VPN server setup completed!"
  depends_on = [null_resource.wait_for_setup]
}

output "server_ip" {
  value      = vultr_instance.vpn.main_ip
  depends_on = [null_resource.wait_for_setup]
}

output "vpn_psk" {
  value = random_string.vpn_psk.result
}

output "vpn_username" {
  value = random_string.vpn_username.result
}

output "vpn_password" {
  value = random_string.vpn_password.result
}
