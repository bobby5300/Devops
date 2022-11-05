data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = var.aws_ami

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}