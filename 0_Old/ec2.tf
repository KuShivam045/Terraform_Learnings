resource "aws_instance" "web" {
    ami = "ami-0ad21ae1d0696ad58"
    instance_type = "t2.micro"
    key_name = "test"
    vpc_security_group_ids = [aws_security_group.security_group_test.id]

    tags = {
        Name = "Test-App-EC2"    
    }
  
}
