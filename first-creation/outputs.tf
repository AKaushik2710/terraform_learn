# This file is for storing output values and taking them into use

# This value demonstrates domain name of instance 
output "domain-name" {
  value = aws_instance.my-ec2.public_dns
}

# This value demonstrates IP address of instance 
output "public-ip" {
  value = aws_instance.my-ec2.public_ip
}