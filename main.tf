provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true


  tags = {
    Name = "Terraform_VPC"
  }
}

resource "aws_subnet" "Terraform_public_subnet" {
  vpc_id                  = aws_vpc.terraform_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "Terraform_public_subnet"
  }
}

resource "aws_internet_gateway" "terraform_IGW" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform_IGW"
  }
}

resource "aws_route_table" "terraform_public_RT" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_IGW.id
  }

  tags = {
    Name = "terraform_public_RT"
  }
}

resource "aws_route_table_association" "terraform_public" {
  subnet_id      = aws_subnet.Terraform_public_subnet.id
  route_table_id = aws_route_table.terraform_public_RT.id
}

resource "aws_instance" "tjinst" {
    ami = "ami-0b08bfc6ff7069aff"
    instance_type = "t2.micro"
    tags = {
       Name = "TFJA-Instance"
    }
}

resource "null_resource" "test" {
    provisioner "local-exec" {
        command = "echo Hello World"
    }
}
