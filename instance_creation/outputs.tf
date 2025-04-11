output "instance_id" {
description = "Instance Id"
value = aws_instance.app_server.id
}

output "public_ip" {
description = "Instance IP"
value =  aws_instance.app_server.public_ip
}
