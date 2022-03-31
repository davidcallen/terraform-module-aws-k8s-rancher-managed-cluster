variable "environment" {
  description = "Environment information e.g. account IDs, public/private subnet cidrs"
  type = object({
    name                         = string # Environment Account IDs are used for giving permissions to those Accounts for resources such as AMIs
    account_id                   = string
    resource_name_prefix         = string # For some environments  (e.g. Core, Customer/production) want to protect against accidental deletion of resources
    resource_deletion_protection = bool
    default_tags                 = map(string)
  })
  default = {
    name                         = ""
    account_id                   = ""
    resource_name_prefix         = ""
    resource_deletion_protection = true
    default_tags                 = {}
  }
}
variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = ""
  validation {
    condition     = length(var.vpc_id) > 0
    error_message = "Error : the variable 'vpc_id' must be non-empty."
  }
}
variable "vpc_private_subnet_ids" {
  description = "The VPC private subnet IDs list"
  type        = list(string)
  default     = []
}
variable "vpc_private_subnet_cidrs" {
  description = "The VPC private subnet CIDRs list"
  type        = list(string)
  default     = []
}
variable "route53_public_hosted_zone_id" {
  description = "Route53 Public Hosted Zone ID (if in use)."
  default     = ""
  type        = string
}
variable "route53_private_hosted_zone_id" {
  description = "Route53 Private Hosted Zone ID (if in use)."
  default     = ""
  type        = string
}
variable "ec2_instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t3a.medium"
}
variable "windows_ec2_instance_type" {
  type        = string
  description = "Instance type used for all EC2 windows instances"
  default     = "t3a.large"
}
variable "docker_version" {
  type        = string
  description = "Docker version to install on nodes"
  default     = "19.03"
}
variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for managed workload cluster"
  default     = "v1.22.5-rancher2-1"
}
variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "1.5.3"
}
variable "windows_prefered_cluster" {
  type        = bool
  description = "Activate windows supports for the custom workload cluster"
  default     = false
}
variable "add_windows_node" {
  type        = bool
  description = "Add a windows node to the workload cluster"
  default     = false
}
variable "cluster_name" {
  type        = string
  description = "Name for managed cluster"
  validation {
    condition     = length(var.cluster_name) > 0
    error_message = "Error : the variable 'cluster_name' must be non-empty."
  }
}
variable "cluster_dns" {
  type        = string
  description = "DNS host name of the Cluster"
}
variable "cluster_ssh_key_name" {
  description = "The SSH Key name to be installed in each ECS Node VM."
  type        = string
  default     = ""
  validation {
    condition     = length(var.cluster_ssh_key_name) > 0
    error_message = "Error : the variable 'cluster_ssh_key_name' must be non-empty."
  }
}
variable "cluster_ssh_private_key_filename" {
  type        = string
  description = "FilePathName of SSH Private Key to be used to connect to cluster."
}
variable "cluster_ingress_allowed_cidrs" {
  description = "The Cluster ingress allowed CIDRs list"
  type        = list(string)
  default     = []
}
variable "global_default_tags" {
  description = "Global default tags"
  default     = {}
  type        = map(string)
}
