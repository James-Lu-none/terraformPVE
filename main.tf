terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

variable "username" {
  description = "Proxmox username"
  type        = string
}

variable "password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}

provider "proxmox" {
  endpoint = "https://192.168.0.100:8006/"
  insecure = true
  username = var.username
  password = var.password
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