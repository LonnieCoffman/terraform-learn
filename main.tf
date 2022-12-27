provider "aws" {
  region  = "us-east-1"
  profile = "iamadmin-general"
}

variable "availability_zone" {
  description = "availability zone"
}
variable "cidr_blocks" {
  description = "cidr blocks"
  type        = list(object({ cidr_block = string, name = string }))
}

resource "aws_vpc" "development-vpc" {
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name : var.cidr_blocks[0].cidr_block
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id            = aws_vpc.development-vpc.id
  cidr_block        = var.cidr_blocks[1].cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name : var.cidr_blocks[1].name
  }
}

data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = var.cidr_blocks[2].cidr_block
  availability_zone = var.availability_zone
  tags = {
    Name = var.cidr_blocks[2].name
  }
}

output "dev-vpc-id" {
  value = aws_vpc.development-vpc.id
}

output "dev-subnet-id" {
  value = aws_subnet.dev-subnet-1.id
}
