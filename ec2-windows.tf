resource "aws_instance" "quickstart_node_win" {
  count                  = var.add_windows_node ? 1 : 0
  ami                    = data.aws_ami.windows.id
  instance_type          = var.windows_ec2_instance_type
  subnet_id              = var.vpc_private_subnet_ids[0]
  key_name               = var.cluster_ssh_key_name
  vpc_security_group_ids = [aws_security_group.rancher_managed_cluster.id]
  get_password_data      = true
  user_data = templatefile(
    join("/", [path.module, "files/userdata_quickstart_windows.template"]),
    {
      register_command = rancher2_cluster_v2.managed_cluster.cluster_registration_token.0.node_command
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
    for instance in aws_instance.quickstart_node_win :
    rsadecrypt(instance.password_data, data.tls_public_key.ssh-key.private_key_pem)
  ]
}
output "windows-workload-ips" {
  value = aws_instance.quickstart_node_win[*].private_ip
}