resource "local_file" "kube_config_managed-cluster_yaml" {
  filename        = format("%s/%s", path.root, "kube_config_managed_cluster-${cluster_name}.yaml")
  content         = rancher2_cluster.managed-cluster.kube_config
  file_permission = "600"
}
