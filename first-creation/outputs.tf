output "domain-name" {
  value = aws_instance.my-ec2.public_dns
}

output "public-ip" {
  value = aws_instance.my-ec2.public_ip
}