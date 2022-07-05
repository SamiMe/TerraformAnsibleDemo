resource "digitalocean_droplet" "web" {
  count  = var.amount_web_servers
  image  = "ubuntu-18-04-x64"
  name   = "web-${count.index}"
  region = "fra1"
  size   = "s-1vcpu-1gb"

  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

  provisioner "remote-exec" {
    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file(var.pvt_key)
    }

    inline = ["sudo apt update"]
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${var.pvt_key} -e 'pub_key=${var.pub_key}' nginx.yml"
  }

}

resource "digitalocean_droplet" "loadbalancer" {
  image  = "ubuntu-18-04-x64"
  name   = "Loadbalancer"
  region = "fra1"
  size   = "s-1vcpu-1gb"

  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
}

resource "null_resource" "haproxy" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i ${var.inventory} --private-key ${var.pvt_key} -e 'pub_key=${var.pub_key}' haproxy.yml"
  }
  depends_on = [
    local_file.AnsibleInventory
  ]
}

output "web_server_ip_addresses" {
  value = {
    for droplet in digitalocean_droplet.web :
    droplet.name => droplet.ipv4_address
  }
}

output "loadbalancer_ip_address" {
  value = digitalocean_droplet.loadbalancer.ipv4_address
}

