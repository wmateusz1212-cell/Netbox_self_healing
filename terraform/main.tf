terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data source to fetch the latest stable Ubuntu 22.04 LTS image
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group: Act as a Cloud Firewall allowing only specific ports
resource "aws_security_group" "lab_sg" {
  name        = "netdevops_lab_sg"
  description = "Strictly manage inbound traffic for NetBox, Grafana, Prometheus and SSH"

  ingress {
    description = "SSH Access for Ansible/Admins"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # In production, restrict this to VPN IPs
  }

  ingress {
    description = "NetBox UI/API (Source of Truth)"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Grafana Observability Dashboard"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "Prometheus Metrics UI"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic (Updates, Git Clone, etc.)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "netdevops-lab-sg"
    Environment = "Lab"
    ManagedBy = "Terraform"
  }
}

# Provisioning the EC2 Instance with Auto-Configuration
resource "aws_instance" "netdevops_lab" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.lab_sg.id]

  # Inject user_data script and render variables (e.g. GitHub URL) into it
  user_data = templatefile("${path.module}/userdata.sh", {
    github_repo_url = var.github_repo_url
  })

  tags = {
    Name = "NetDevOps-Self-Healing-Engine"
    Role = "Automation-Server"
  }
}
