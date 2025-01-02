terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}


variable "virtual_environment_endpoint" {
  description = "Proxmox virtual environment endpoint"
  type        = string
}

variable "virtual_environment_api_token" {
  description = "Proxmox virtual environment api token"
  type        = string
  sensitive   = true
}

variable "virtual_environment_ssh_username" {
  description = "Proxmox virtual environment ssh username"
  type        = string
}

provider "proxmox" {
  endpoint = var.virtual_environment_endpoint
  api_token = var.virtual_environment_api_token
  insecure = true
  ssh {
    agent = true
    username = var.virtual_environment_ssh_username
  }
}


resource "proxmox_vm_qemu" "vm-instance" {
  name = "test-vm"
  target_node = "pve3"
  clone = "deb12-base"
  full_clone = true
  cores = 2
  memory = 2048
  
  disk {
    size = "32G"
    type = "scsi"
    storage = "local-lvm"
    discard = "on"
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
    firewall = false
    link_down = false
  }  
}