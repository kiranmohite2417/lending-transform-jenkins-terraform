output "key_name" {
  value = aws_key_pair.deployer.key_name
}

output "frontend_instances_ids" {
  value = aws_instance.frontend_instances[*].id
}

output "backend_instances_ids" {
  value = aws_instance.backend_instances[*].id
}

output "bastion_instance_id" {
  value = aws_instance.bastion_host.id
}

