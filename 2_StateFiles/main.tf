provider "aws" {
    region = "ap-south-1"
  
}

resource "aws_instance" "nothing" {
    ami = "ami-0ad21ae1d0696ad58"
    instance_type = "t2.micro"
    key_name = "test"
    tags = {
      Name="Nothing"
    }
  
}

resource "aws_s3_bucket" "s3_bucket" {
    bucket = "shivaay0251998"
  
}

resource "aws_dynamodb_table" "terraform_lock" {
    name = "terraform-lock"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
      name = "LockID"
      type = "S"
    }
  
}