# modules/proxmox-vm/main.tf
resource "proxmox_vm_qemu" "vm" {
  for_each = { for i in range(var.vm_count) : i => i }

  name        = "${var.name_prefix}${each.key + 1}"
  target_node = var.target_nodes[each.key % length(var.target_nodes)]
  boot = var.iso_file != null ? "order=virtio0;ide2" : null
  bios  = "ovmf"
  scsihw = var.iso_file != null ? "virtio-scsi-pci" : null

  cpu {
    sockets = var.sockets
    cores   = var.cores
  }
  
  memory              = var.memory_mb
  agent               = 1
  start_at_node_boot  = true
  skip_ipv6           = true

  # Only set clone/full_clone if clone_from is provided, otherwise Proxmox API rejects the request
  clone               = var.clone_from != null ? var.clone_from : null
  full_clone          = var.clone_from != null ? true : null

  efidisk {
    efitype = "4m"
    storage = var.storage
    pre_enrolled_keys = false
  }

  tpm_state {
    version = "v2.0"
    storage = var.storage
  }

  dynamic "disks" {
    for_each = var.iso_file != null ? [1] : []
    content {
    virtio {
      virtio0 {
        disk {
          storage = var.storage
          size    = "${var.disk_gb}G"
        }
      }
    }

   ide {
            ide2 {
                cdrom {
                iso = "${var.iso_storage}:iso/${var.iso_file}"
                }
            }
        }
    }
  }

  network {
    id     = 0
    model  = "virtio"
    bridge = var.bridge
    tag    = var.vlan_tag
  }

  tags = length(local.tags_clean) > 0 ? join(";", local.tags_clean) : null
}


# modules/proxmox-vm/outputs.tf
output "vmids" {
  value = { for k, v in proxmox_vm_qemu.vm : k => v.vmid }
}

output "names" {
  value = { for k, v in proxmox_vm_qemu.vm : k => v.name }
}

output "ipv4_addresses" {
  description = "Default IPv4 addresses reported by qemu-guest-agent for each VM"
  value       = { for k, v in proxmox_vm_qemu.vm : k => v.default_ipv4_address }
}