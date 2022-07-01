terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

//SSH key name in digitalocean
data "digitalocean_ssh_key" "terraform" {
  name = "Terraform-Ansible"
}
