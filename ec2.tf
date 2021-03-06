locals {
  node_username = "ec2-user"
}
data "tls_public_key" "ssh-key" {
  private_key_pem = file(var.cluster_ssh_private_key_filename)
}

# Security group to allow all traffic
resource "aws_security_group" "rancher-managed-cluster" {
  name        = "${var.environment.resource_name_prefix}-rancher-managed-cluster"
  description = "Rancher managed (workload) cluster"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = var.cluster_ingress_allowed_cidrs
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.global_default_tags, {
    Name = "${var.environment.resource_name_prefix}-rancher-managed-cluster"
  })
}

# AWS EC2 instance for creating a single-node rancher managed (workload) cluster with k3s installed (non-HA)
resource "aws_instance" "rancher-managed-cluster" {
  ami                    = data.aws_ami.sles.id
  instance_type          = var.ec2_instance_type
  key_name               = var.cluster_ssh_key_name
  vpc_security_group_ids = [aws_security_group.rancher-managed-cluster.id]
  subnet_id              = var.vpc_private_subnet_ids[0]
  user_data = templatefile(
    join("/", [path.module, "files/userdata_rancher-managed-cluster.template"]),
    {
      docker_version     = var.docker_version
      username           = local.node_username
      kubernetes_version = var.kubernetes_version
      k3s_deploy_traefik = (var.k3s_deploy_traefik) ? "" : "--no-deploy traefik"
      install_nginx_ingress = var.install_nginx_ingress
      register_command   = (var.rancher_server_use_self_signed_certs) ? rancher2_cluster_v2.managed-cluster.cluster_registration_token.0.insecure_node_command : rancher2_cluster_v2.managed-cluster.cluster_registration_token.0.node_command
    }
  )
  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]
    connection {
      type        = "ssh"
      host        = self.private_ip
      user        = local.node_username
      private_key = data.tls_public_key.ssh-key.private_key_pem
    }
  }
  tags = merge(var.global_default_tags, {
    Name = "${var.environment.resource_name_prefix}-rancher-managed-cluster"
  })
}
