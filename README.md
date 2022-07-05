# TerraformAnsibleDemo
Create web servers and load balancer with Terraform and Ansible in Digitalocean.
1. Terraform creates X amount(asked from user) VM's, web-servers
2. Ansible will install and configure NGINX in every web-server
3. Terraform creates VM for HAProxy
4. Terraform creates Ansible inventory file
5. Ansible will install and configure HAproxy

![Instance](/pictures/Terraform.png)



## Prerequisites
- DigitalOcean account. 
- DigitalOcean Personal Access Token and SSH keys
- Terraform and Ansible installed on your local machine


## Usage
- Clone repository 
- Add SSH keys in keys-folder

Create instance:
```bash
terraform apply -var "do_token=add_Digitalocean_token"
```
The user is asked how many web servers will be built.  
Once the instance is up, users can access `http://haproxy_ip:8080`

Remove instance:
```bash
terraform destroy -var "do_token=add_Digitalocean_token"
```