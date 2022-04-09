resource "aws_instance" "rancher-managed-cluster-win" {
  count                  = var.add_windows_node ? 1 : 0
  ami                    = data.aws_ami.windows.id
  instance_type          = var.windows_ec2_instance_type
  subnet_id              = var.vpc_private_subnet_ids[0]
  key_name               = var.cluster_ssh_key_name
  vpc_security_group_ids = [aws_security_group.rancher-managed-cluster.id]
  get_password_data      = true
  user_data = templatefile(
    join("/", [path.module, "files/userdata_rancher-managed-cluster-windows.template"]),
    {
      register_command = (var.rancher_server_use_self_signed_certs) ? rancher2_cluster.managed-cluster.cluster_registration_token.0.insecure_windows_node_command : rancher2_cluster.managed-cluster.cluster_registration_token.0.windows_node_command
    }
  )
  root_block_device {
    volume_size = 50
  }
  tags = merge(var.global_default_tags, {
    Name = "${var.environment.resource_name_prefix}-rancher-managed-cluster"
  })
}
output "windows_password" {
  description = "Returns the decrypted AWS generated windows password"
  sensitive   = true
  value = [
    for instance in aws_instance.rancher-managed-cluster-win :
    rsadecrypt(instance.password_data, data.tls_public_key.ssh-key.private_key_pem)
  ]
}
output "windows-workload-ips" {
  value = aws_instance.rancher-managed-cluster-win[*].private_ip
}