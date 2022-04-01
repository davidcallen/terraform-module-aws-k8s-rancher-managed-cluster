output "custom_cluster_command" {
  value       = rancher2_cluster_v2.managed_cluster.cluster_registration_token.0.node_command
  description = "Docker command used to add a node to the quickstart cluster"
}
output "custom_cluster_windows_command" {
  value       = rancher2_cluster_v2.managed_cluster.cluster_registration_token.0.windows_node_command
  description = "Docker command used to add a windows node to the quickstart cluster"
}
output "workload_node_ip" {
  value = aws_instance.rancher_managed_cluster.private_ip
}