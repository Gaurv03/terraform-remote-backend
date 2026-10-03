# key pair
resource "aws_key_pair" "deployer" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# VPC & security groups
resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "my_security_group" {
  name        = "automate-sg"
  description = "this will add a TF generated SG"
  vpc_id      = aws_default_vpc.default.id

  tags = {
    name = "automate-sg"
  }

  # inbound rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP open"
  }

  # outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }


}

# ec2 instance
resource "aws_instance" "my_instance" {
  for_each = tomap({
    tws-automate-t2 = "t2.micro"
    tws-automate-t3 = "t3.micro"
    tws-automate-t3-small = "t3.small"
  })

  depends_on = [aws_security_group.my_security_group, aws_key_pair.deployer]

  key_name        = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.my_security_group.name]
  instance_type   = each.value
  ami             = var.ec2_ami_id #ubuntu

  user_data = file("install-nginx.sh")

  root_block_device {
    volume_size = var.env =="prd" ? 10 : var.ec2_default_root_storage_size
    volume_type = "gp3"
  }

  tags = {
    Name = each.key
  }
}
