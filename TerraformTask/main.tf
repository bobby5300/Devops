provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAXSPSBJQUN7S5IT32"
  secret_key = "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"
}

resource "aws_instance" "TF_Instance" {
  ami           = "ami-05fa00d4c63e32376" # us-west-2
  instance_type = "t2.micro"

  key_name = aws_key_pair.TF_key_pair.id

  security_groups = [aws_security_group.TF_SG.name]

  // Connect via SSH need to enable Public IP

  associate_public_ip_address = true

  tags = {
    Name = "Terraform Ec2"
  }
}

// Output IP Address

output "InstanceIP" {
  description = "The Public IP for SSH Access"
  value       = aws_instance.TF_Instance.public_ip
}

// Create SSH-Key

resource "tls_private_key" "TF_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate a Private Key and encode it as PEM.
resource "aws_key_pair" "TF_key_pair" {
  key_name   = "key"
  public_key = tls_private_key.TF_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.TF_key.private_key_pem}' > ./key.pem"
  }
}

# This resource will destroy (potentially immediately) after null_resource.next
resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "30s"
}

# This resource will create (at least) 30 seconds after null_resource.previous
resource "null_resource" "next" {
  depends_on = [time_sleep.wait_30_seconds]
}

// AWS Scecurity Group

resource "aws_security_group" "TF_SG" {
  name        = "Security group using Terraform"
  description = "Security group using Terraform"


  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF_SG"
  }
}