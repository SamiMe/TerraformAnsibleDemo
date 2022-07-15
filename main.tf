# Create web server droplets
resource "digitalocean_droplet" "web" {
  count  = var.amount_web_servers
  image  = "ubuntu-18-04-x64"
  name   = "web-${count.index}"
  region = "fra1"
  size   = "s-1vcpu-1gb"

  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
}

# Create loadbalanser droplet
resource "digitalocean_droplet" "loadbalancer" {
  image  = "ubuntu-18-04-x64"
  name   = "Loadbalancer"
  region = "fra1"
  size   = "s-1vcpu-1gb"

  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
}

# Install nginx on the web servers
resource "null_resource" "nginx" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i ${var.inventory} --private-key ${var.pvt_key} -e 'pub_key=${var.pub_key}' nginx.yml"
  }
  depends_on = [
    local_file.AnsibleInventory
  ]
}

# Install haproxy on the loadbalancer
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

