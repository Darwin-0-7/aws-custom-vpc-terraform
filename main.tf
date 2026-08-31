provider "aws" {
  region = "ap-south-1"
}

resource "aws_vpc" "my_custom_vpc" {
  cidr_block		= "10.0.0.0/16"
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = {
    Name = "Darwin_VPC"
  }
}

#Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id		  = aws_vpc.my_custom_vpc.id
  cidr_block		  = "10.0.1.0/24"
  availability_zone	  = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Darwin_Public_Subnet"
  }
}

#Private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id		  = aws_vpc.my_custom_vpc.id
  cidr_block		  = "10.0.2.0/24"
  availability_zone	  = "ap-south-1b"

  tags = {
    Name = "Darwin_Private_Subnet"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_custom_vpc.id
  
  tags = {
    Name = "Darwin-IGW"
  }
}

#Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_custom_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
 
  tags = {
    Name = "Darwin_Public_RT"
  }
}

#Route Table Association
resource "aws_route_table_association" "pulic_rt_assoc" {
  subnet_id	 = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

#Security Group for Web Server
resource "aws_security_group" "web_sg" {
  name	      = "Darwin_Web_SG"
  description = "Allow HTTP and SSH inbound trafiic"
  vpc_id      =  aws_vpc.my_custom_vpc.id

  #Inbound Rules
  ingress {
    from_port	  = 80
    to_port	  = 80
    protocol	  = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]  #For Clients
  }

  ingress {
    from_port	  = 22
    to_port	  = 22
    protocol	  = "tcp"
    cidr_blocks   = ["0.0.0.0/0"] #SSH Access
  }

  #Outbound Rules
  egress {
    from_port    = 0
    to_port	 = 0
    protocol	 = "-1" #all traffic
    cidr_blocks  = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Darwin_Web_SG"
  }
}

#EC2 Instance (Web Server)
resource "aws_instance" "web_server" {
  ami            = "ami-0287a05f0ef0e9d9a" #Ubuntu 22.04 LTS (Mumbai Region)
  instance_type  = "t2.micro"                 #Free Tier

  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  #Auto Insatll Apache Web Server
  user_data = <<-EOF
              #!/bin/bash
	      sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo systemctl enable apache2
              echo "<h1>Darwin's Web Server is Live!<h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "Darwin_Web_Server"
  }
}

#Output the Public Ip to Terminal
output "web_server_ip" {
  value = aws_instance.web_server.public_ip
}
