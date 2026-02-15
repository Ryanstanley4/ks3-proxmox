locals {
  tags_clean = [for t in var.tags : trimspace(t)]
}
