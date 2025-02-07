provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["leeprod-vpc"]
  }
}

data "aws_subnet" "private_a" {
  filter {
    name   = "tag:Name"
    values = ["leeprod-subnet-private-a"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

data "aws_subnet" "private_b" {
  filter {
    name   = "tag:Name"
    values = ["leeprod-subnet-private-b"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}
