provider "aws" {
    region = "ap-south-1"
  
}

variable "cidr" {
    default = "10.0.0.0/16"
  
}

resource "aws_key_pair" "example" {
    key_name = "terraform-demo"  # Replace with your desired key name
    public_key = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key file
  
}

resource "aws_vpc" "my_vpc" {
    cidr_block = var.cidr
  
}

resource "aws_subnet" "sub1" {
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my_vpc.id
     
}

resource "aws_route_table" "RT" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "rta" {
    subnet_id = aws_subnet.sub1.id
    route_table_id = aws_route_table.RT.id
    
}


resource "aws_security_group" "websg" {
    name = "web"
    vpc_id = aws_vpc.my_vpc.id

    ingress {
        description = "HTTP from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
        ingress {
        description = "testing port from VPC"
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
    tags = {
      Name = "Web-sg"
    }
}

resource "aws_instance" "server" {
    ami = "ami-0ad21ae1d0696ad58"
    instance_type = "t2.micro"
    key_name = aws_key_pair.example.key_name
    vpc_security_group_ids = [aws_security_group.websg.id]
    subnet_id = aws_subnet.sub1.id

    connection {
        type = "ssh"
        user = "ubuntu"   # Replace with the appropriate username for your EC2 instance
        private_key = file("~/.ssh/id_rsa")   # Replace with the path to your private key
        host = self.public_ip
    
    }

    # File provisioner to copy a file from local to the remote EC2 instance
    provisioner "file" {
        source = "app.py"  # Replace with the path to your local file
        destination = "/home/ubuntu/app.py"   # Replace with the path on the remote instance
            
    }

    provisioner "remote-exec" {
        inline = [ 
            "echo 'Hello form the remote instance'",
            "sudo apt-get update && sudo apt-get upgrade -y",  # Update package lists (for ubuntu)
            "sudo apt-get install -y python3-pip python3-venv", # Example package installation
            "python3 -m venv /home/ubuntu/venv",
            "/home/ubuntu/venv/bin/pip install flask",
            "nohup /home/ubuntu/venv/bin/python /home/ubuntu/app.py > /home/ubuntu/app.log 2>&1 &"

         ]      
    }
}