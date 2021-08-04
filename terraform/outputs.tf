output "app-server-1_id" {
  description = "App-1 instance ID."
  value       = aws_instance.app-server-1.id
}

output "app-server-1_ip" {
  description = "App-1 private IP address."
  value       = aws_instance.app-server-1.private_ip
}


output "app-server-2_id" {
  description = "App-2 instance ID."
  value       = aws_instance.app-server-2.id
}

output "app-server-2_ip" {
  description = "App-2 private IP address."
  value       = aws_instance.app-server-2.private_ip
}
