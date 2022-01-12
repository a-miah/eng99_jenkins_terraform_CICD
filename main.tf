# Let terraform know who is our provider 

# AWS plugins/dependencies will be downloaded
provider "aws" {
  region = "eu-west-1"
  # This will allow terraform to create services on eu-west-1
}


# Creating a VPC


resource "aws_vpc" "vpc_terraform" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"    
    
    tags = {
        Name = "eng99_attaik_terraform_vpc"
    }
}


# Internet Gateway
resource "aws_internet_gateway" "terraform_IG" {
  vpc_id = aws_vpc.vpc_terraform.id

  tags = {
    Name = "eng99_attaik_terraform_IG"
  }
}


# Public subnet

resource "aws_subnet" "app_subnet" {
  vpc_id = aws_vpc.vpc_terraform.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "eng99_attaik_terraform_public_sn"
  }
}


# Route table

resource "aws_route_table" "terraform_RT" {
  vpc_id = aws_vpc.vpc_terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_IG.id
  }

  tags = {
    Name = "eng99_attaik_terraform_RT"
  }
}

# Route association 

resource "aws_route_table_association" "terraform_association_RT" {
  subnet_id = aws_subnet.app_subnet.id
  route_table_id = aws_route_table.terraform_RT.id
}

# Let's start with launching EC2 instance using terraform script
# App Instance

resource "aws_instance" "app_instance" {
  ami = var.app_ami_id # ami id for 18.04LTS ubuntu
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.app_subnet.id
  security_groups = [aws_security_group.app_security_group.id]
  tags = {
    Name = "eng99_attaik_terraform_app"
  }
  key_name = "eng99" # ensure that we have this key in .ssh folder
}

resource "aws_instance" "db_instance" {
  ami = var.app_ami_id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = aws_subnet.app_subnet.id
  vpc_security_group_ids = [aws_security_group.db_security_group.id]

  tags = {
    Name = "eng99_attaik_terraform_db"
  }
  key_name = "eng99"
}


# To initialise we use terraform init
# terraform plan - checks file for errors
# terraform apply - launches ec2 on aws
# terraform destroy - kills ec2 



# Create security groups 
# Inbound rules - ingress
# Outbound rules - egress

# app security group

resource "aws_security_group" "app_security_group" {
  name = "eng99_attaik_terraform_app"
  description = "app security group"
  vpc_id = aws_vpc.vpc_terraform.id  # link SG with VPC


  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# allow ssh into instance
  ingress { 
    from_port = "22"
    to_port = "22"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
# app listens to this port 
  ingress {
    from_port = "3000"
    to_port = "3000"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

# outbound rules
  egress { 
    from_port = 0 
    to_port = 0
    protocol = "-1" #allow all
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eng99_attaik_terraform_public_sg"
  }
}


# db security group

resource "aws_security_group" "db_security_group" {
  name = "eng99_attaik_terraform_db_sg"
  description = "db security group"
  vpc_id = aws_vpc.vpc_terraform.id

  ingress {
    from_port = 27017
    to_port = 27017
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
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
    Name = "eng99_attaik_terraform_db_sg"
  }

}