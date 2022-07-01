variable "do_token" {}

variable "pvt_key" {
  type        = string
  default     = "./keys/digitalocean"
  description = "SSH private key"
}

variable "pub_key" {
  type        = string
  default     = "./keys/digitalocean.pub"
  description = "SSH public key"
}

variable "inventory" {
  type        = string
  default     = "./inventory/hosts"
  description = "Inventory file"
}