variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "instance_count" {
  default = 2
}

variable "instance_type" {
  type=string
}

variable "aws_ami" {
  type=list(string)
}