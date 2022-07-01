### Create Ansible inventory file
resource "local_file" "AnsibleInventory" {
  content = templatefile("inventory/inventory.tmpl",
    {
      web-vm-ip = [for u in digitalocean_droplet.web : u.ipv4_address],
      lb-vm-ip  = "${digitalocean_droplet.loadbalancer.ipv4_address}"
    }

  )
  filename = "./inventory/hosts"

  depends_on = [
    digitalocean_droplet.loadbalancer
  ]
}


