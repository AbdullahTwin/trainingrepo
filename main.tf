terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>3.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "example" {
  ami = "ami-05eb46f888200e84d" //Ubuntu 20.04 eu-west-2
  instance_type = "t2.micro"
}