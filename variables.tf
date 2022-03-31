variable "aws_instance_type" {
  type = string
  default = "t2.micro"
  description = "Provide the instance type for your VM."
}

/*
variable "aws_vpc_id" {
  type = string
  description = "Provide the Custom VPC ID if you use one."
}
*/
variable "my_ip_with_cidr" {
  type = list
  description = "Provide your public ip."
}

variable "public_key" {
  type = string
  sensitive = true
}

variable "server_name" {
  type = string
  default = "TerraServer"
  description = "Provide a Servername for your Instance."
}