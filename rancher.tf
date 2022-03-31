# Rancher resources

locals {
  rke_network_plugin = var.windows_prefered_cluster ? "flannel" : "canal"
  rke_network_options = var.windows_prefered_cluster ? {
    flannel_backend_port = "4789"
    flannel_backend_type = "vxlan"
    flannel_backend_vni  = "4096"
  } : null
}

# TODO : support HA multi-node Cluster
# Create a new rancher v2 RKE multi-node Cluster v2 (HA)
//resource "rancher2_cluster" "quickstart_workload" {
//  provider = rancher2.admin
//
//  name        = var.cluster_name
//  description = "Custom workload cluster created by Rancher quickstart"
//
//  rke2_config {
//    network {
//      plugin  = local.rke_network_plugin
//      options = local.rke_network_options
//    }
//    kubernetes_version = var.kubernetes_version
//  }
//  windows_prefered_cluster = var.windows_prefered_cluster
//}

# Create a new rancher v2 K3S custom Cluster v2 (non-HA)
resource "rancher2_cluster_v2" "managed_cluster" {
  provider                                 = rancher2.admin
  name                                     = var.cluster_name
  kubernetes_version                       = var.kubernetes_version
  enable_network_policy                    = false
  default_cluster_role_for_project_members = "user"
  # TODO : add support for multi-node (HA) RKE installation
  //  rke_config {
  //    network {
  //      plugin  = local.rke_network_plugin
  //      options = local.rke_network_options
  //    }
  //    kubernetes_version = var.kubernetes_version
  //  }
  //  windows_prefered_cluster = var.windows_prefered_cluster
}