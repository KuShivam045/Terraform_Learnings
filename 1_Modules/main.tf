provider "aws" {
    region = "ap-south-1"
      
}

module "ec2_instances" {
    source = "./modules/ec2_instances"
    ami_value = "ami-0ad21ae1d0696ad58"
    instance_type = "t2.micro"
  
}