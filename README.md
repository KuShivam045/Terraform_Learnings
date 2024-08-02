# AWS Instance Creation using Terraform

This Terraform configuration creates an AWS instance in the AP-South-1 region.

## Requirements

* Terraform installed on your machine
* AWS account with necessary credentials set up
* A key pair named "test" created in your AWS account

## Variables

* `ami_value`: The ID of the Amazon Machine Image (AMI) to use for the instance.
* `instance_type`: The type of instance to create (e.g., t2.micro, c5.xlarge, etc.).

## Usage

1. Initialize the Terraform working directory by running `terraform init`.
2. Set the `ami_value` and `instance_type` variables in a `terraform.tfvars` file or using the `-var` option when running `terraform apply`.
3. Run `terraform apply` to create the AWS instance.

Example `terraform.tfvars` file:
```terraform
ami_value = "ami-0c94855ba95c71c99"
instance_type = "t2.micro"