provider "aws" {
    region = "ap-south-1"
  
}

variable "ami" {
    description = "This is AMI for the Instance"
  
}

variable "instance_type" {
    description = "This is Intstance Type"
  
}

resource "aws_instance" "example" {
    ami = var.ami
    instance_type = var.instance_type
  
}