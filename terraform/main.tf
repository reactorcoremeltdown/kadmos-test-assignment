terraform {
  backend "http" {
    address = "https://webdav.rcmd.space/terraform.tfstate"
    update_method = "PUT"
  }
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
  }
}

variable "hcloud_token" {
  sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}
