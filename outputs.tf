output "private_ip" {
  value       = aws_instance.terraserver.private_ip
  description = "The private IP address of the main server instance."
}

output "public_ip" {
  value       = aws_instance.terraserver.public_ip
  description = "The public IP address of the main server instance."
}