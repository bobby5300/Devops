terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

provider "aws" {
  region                  = var.region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "VSTerraform"
}

// Locals start 

locals {
  stagging_env = "stagging"
}

//VPC

resource "aws_vpc" "stagging-vpc" {
  cidr_block = "10.5.0.0/16"

  tags = {
    name = "${local.stagging_env}-vpc-tag"
  }
}

// subnet

resource "aws_subnet" "stagging-subnet" {
  vpc_id     = aws_vpc.stagging-vpc.id
  cidr_block = "10.5.0.0/16"

  tags = {
    name = "${local.stagging_env}-subnet-tag"
  }

}

// Local Ends

// output Values Start 

output "My_demo_output" {
  value = "Hello This is the static Output"
  sensitive = true
}

output "Output_EC2_IP" {
  value = aws_instance.EC2.public_ip
}

// output value end

resource "aws_instance" "EC2" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.InstanceType
  //count                       = var.instanceCount
  associate_public_ip_address = var.EnablepublicIp            // Public IP Enable
  subnet_id                   = aws_subnet.stagging-subnet.id // subnet id Local

  // tags = var.project_Enviroment

  tags = {
    Name = var.environment_name
  }

}



// add IAM Users

//resource "aws_iam_user" "Users" {

//count = length(var.user_names)
//name  = var.user_names[count.index]
//}



data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

