This is a Terraform Module to deploy an AWS EC2 instance running Apache webserver.
This is a test-module for test-use only. Do not use in Production!

```hcl
terraform {
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

module "apache" {
  source = ".//terraform-aws-apache-example"
  aws_instance_type = "t2.micro"
  server_name = "Apache-TestServer"
  my_ip_with_cidr = ["178.118.151.108/32"]
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC4LSNYrWAHACtTPDkyZ+wstFPv7YFqMubILCq9QPEFbbxxuWWUKM1OaKk/v8zdKK1wo4mwHs1QaLEsEZCr1Lp4buZftFh2w+ed6ZEFJESBRGn6s8+ho1At8ps4IXf1rTsxUJ01SWfNMhPVmZiNsnG5dT5286pQH8rtsqjclB8C/8Idd9v6RTPy6vNRaYwto8fLjTjPJ4dmKr0/i43Gub0/fAp9fCr06xKw4U337QDMgzmFSIH3P3+AurK5BJsU4Qil1ijRplbh+MLPE+OHZquXZLhk1yUZ1MW6WkLH6YhumcSvruxgaLIT9QAR7vDFuQ9xgDtScs4UVBuBsFPHS/3A29mlgKL8RUdwfPNyu1sPSIeIu10RBHWwXqj5zRNdjySk18RM5RPOgfRoURboGRA9gtKJmGBQDE+9yxvCkkK9OXGBWvewfFee5GLYVldJph1LPW65qFq2FC4ehg5mbq2ulavvOdJSXzMl/n6tKmWLaZm+f8EsAe14Y37x/BWCao0= root@PC-P5Y"
}

output "private_ip" {
  value = module.AWS.private_ip
}

output "public_ip" {
  value = module.AWS.public_ip
}
´´´
