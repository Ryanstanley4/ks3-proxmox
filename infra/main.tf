module "control_vms" {
  source       = "./modules/proxmox-vm"
  name_prefix  = "k3s-control-"
  vm_count     = 3
  target_nodes = ["monaco","suzuka", "monza"]
  storage      = "k3s"
  tags         = ["k3s_cluster","terraform", "control_plane"]
  clone_from   = "106"
}


module "worker_vms" {
  source       = "./modules/proxmox-vm"
  name_prefix  = "k3s-worker-"
  vm_count     = 3
  target_nodes = ["monaco","suzuka", "monza"]
  storage      = "k3s"
  tags         = ["k3s_cluster","terraform", "worker_node"]
  clone_from   = "106"
}