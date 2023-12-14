output "vm_pass" {
  sensitive = true
  value = random_password.vm_password
}

output "server-data" {
  value       = [for vm in aws_instance.vm[*] : {
    ip_address  = vm.public_ip
  }]
  description = "The public IP of the servers"
}