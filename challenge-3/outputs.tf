output "public_ip" {
    value = aws_eip.eip.public_ip
}

output "instance_ip" {
  value = aws_instance.citadel.public_ip
}