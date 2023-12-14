variable "vm_count" {
  description = "Number of VMs to create"
  type        = number
  default     = 2
}

variable "vm_flavor" {
  description = "VM flavor"
  type        = string
  default     = "t2.micro"
}

variable "vm_image" {
  description = "VM image"
  type        = string
  default     = "ami-0fc5d935ebf8bc3bc" # Ubuntu Server 22.04 LTS (HVM), SSD Volume Type"  # Replace with your actual Amazon Linux AMI
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "172.31.0.0/24"
}

variable "subnet_cidr" {
  description = "Subnet CIDR block"
  type        = string
  default     = "172.31.0.0/24"
}

variable "instance_tags" {
  type = list(string)
  default = ["tf-ansible-1", "tf-ansible-2", "tf-ansible-3"]
}
