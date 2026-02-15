module "control_vms" {
  source       = "./modules/proxmox-vm"
  name_prefix  = "talos-control-"
  vm_count     = 1
  target_nodes = ["suzuka", "monaco", "monza"]
  storage      = "talos"
  tags         = ["talos_cluster","terraform", "control_plane"]
  iso_file     = "metal-amd64.iso"
}