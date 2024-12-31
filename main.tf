terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
  }
}

variable "pm_api_token_id" {
  description = "Proxmox API Token ID"
  type        = string
}

variable "pm_api_token_secret" {
  description = "Proxmox API Token Secret"
  type        = string
  sensitive   = true
}

variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = true
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