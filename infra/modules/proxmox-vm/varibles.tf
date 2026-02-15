# modules/proxmox-vm/variables.tf
variable "name_prefix" {
  type        = string
  description = "Prefix for VM names"
}

variable "vm_count" {
  type        = number
  description = "Number of VMs to create"
  default     = 1
}

variable "target_nodes" {
  type        = list(string)
  description = "List of Proxmox nodes to spread VMs across"
}

variable "storage" {
  type = string
}

variable "disk_gb" {
  type    = number
  default = 50
}

variable "cores" {
  type    = number
  default = 2
}

variable "sockets" {
  type    = number
  default = 1
}

variable "memory_mb" {
  type    = number
  default = 4096
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "vlan_tag" {
  type    = number
  default = 0
}

variable "tags" {
  type    = list(string)
  default = ["terraform"]
  validation {
    condition = alltrue([for t in var.tags : can(regex("^[A-Za-z0-9][A-Za-z0-9._-]*$", t))])
    error_message = "Each tag must start with a letter/number and contain only A–Z, a–z, 0–9, '-', '.', '_'."
  }
}

variable "iso_storage" {
  type = string
  default = "local"
}

variable "iso_file" {
  type = string 
  default = null
}

variable "wait_for_ipv4" {
  type        = bool
  default     = true
  description = "Wait for IPv4 address from qemu-guest-agent. Set false to make destroy more reliable; provider won't require IPv4 but still records it if available."
}

variable "agent_timeout" {
  type        = number
  default     = 30
  description = "Seconds to wait for qemu-guest-agent IP. Lower to speed up destroy in flaky environments."
}

variable "clone_from" {
  type        = string
  default     = null
  description = "VMID to clone from. If null."
}