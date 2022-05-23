output "webserver_instance_id" {
  value       = aws_instance.my_webserver.id
  description = "Id of EC2"
}

output "webserver_instance_id_2" {
  value       = aws_instance.my_webserver_2.id
  description = "Id of second EC2"
}
