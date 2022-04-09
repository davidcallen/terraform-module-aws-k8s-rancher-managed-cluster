resource "aws_route53_record" "managed-cluster" {
  count           = (length(var.cluster_dns) > 0) ? 1 : 0
  name            = var.cluster_dns
  zone_id         = var.route53_private_hosted_zone_id
  records         = [aws_instance.rancher-managed-cluster.private_ip]
  ttl             = 60
  type            = "A"
  allow_overwrite = true
}