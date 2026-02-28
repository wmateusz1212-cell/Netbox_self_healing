variable "aws_region" {
  description = "The AWS region to deploy into"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "EC2 Instance Type for the NetDevOps Lab"
  type        = string
  default     = "t3.medium" # Minimum recommended for NetBox + Monitoring stack
}

variable "github_repo_url" {
  description = "URL of the NetDevOps Git repository"
  type        = string
  default     = "https://github.com/wmateusz1212-cell/Netbox_self_healing.git"
}
