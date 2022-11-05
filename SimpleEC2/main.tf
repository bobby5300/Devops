resource "aws_instance" "EC2" {
  
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  count = var.instance_count

  tags = {

    Name="Terraform - ${count.index}"

  }

}