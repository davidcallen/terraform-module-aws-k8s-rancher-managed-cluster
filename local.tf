resource "local_file" "kube_config_managed_cluster_yaml" {
  filename        = format("%s/%s", path.root, "kube_config_managed_cluster.yaml")
  content         = rancher2_cluster_v2.managed_cluster.kube_config
  file_permission = "600"
}
