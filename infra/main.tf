module "control_vms" {
  source       = "./modules/proxmox-vm"
  name_prefix  = "k3s-control-"
  vm_count     = 1
  target_nodes = ["suzuka", "monaco", "monza"]
  storage      = "k3s"
  tags         = ["k3s_cluster","terraform", "control_plane"]
  clone_from   = "k3s-template-16-02-26"
}