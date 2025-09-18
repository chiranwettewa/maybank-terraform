data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}


resource "aws_instance" "ssm_host" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_a_id
  vpc_security_group_ids = [var.sg_ssm]
}

resource "aws_launch_template" "server" {
  name_prefix = "server-"
  image_id =data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [var.sg_ec2]
}

resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = [var.private_subnet_b_id, var.private_subnet_a_id]
  desired_capacity = 2
  max_size = 5
  min_size = 1
  launch_template {
    id      = aws_launch_template.server.id
  }
  target_group_arns = [var.nlb_tg]
}