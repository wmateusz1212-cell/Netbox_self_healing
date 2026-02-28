output "lab_public_ip" {
  description = "The public IP address of the newly provisioned NetDevOps Lab server"
  value       = aws_instance.netdevops_lab.public_ip
}

output "netbox_url" {
  description = "URL to access the NetBox Source of Truth"
  value       = "http://${aws_instance.netdevops_lab.public_ip}:8000"
}

output "grafana_url" {
  description = "URL to access the Network Observability Dashboard (Grafana)"
  value       = "http://${aws_instance.netdevops_lab.public_ip}:3000"
}

output "prometheus_url" {
  description = "URL to access raw Prometheus metrics"
  value       = "http://${aws_instance.netdevops_lab.public_ip}:9090"
}
