terraform {
  backend "s3" {
    bucket = "shivaay0251998"
    key = "/shivay/terraform.tfstate"
    encrypt = true
    dynamodb_table = "terraform-lock"

    
  }
}