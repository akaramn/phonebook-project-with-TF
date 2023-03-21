data "aws_ami" "amazon-linux-2" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm*"]
  }
}


data "template_file" "phonebook" {
  template = file("userdata.sh")
  vars = {
    user-data-git-token = var.git-token
    user-data-git-name  = var.git-name
    db-endpoint         = aws_db_instance.RDS.address
  }
}

resource "aws_launch_template" "LT" {
  name                   = "phonebook-lt"
  image_id               = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance-type
  key_name               = var.key-name
  vpc_security_group_ids = [aws_security_group.ec2-sec-grp.id]
  user_data              = base64encode(data.template_file.phonebook.rendered)
  depends_on             = [aws_db_instance.RDS]


  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = " ${var.environment} ec2 instance"
    }
  }
}

resource "aws_autoscaling_group" "ASG" {
  name                      = "Phonebook-ASG"
  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  target_group_arns         = [aws_lb_target_group.TG-ALB.arn]
  vpc_zone_identifier       = [aws_subnet.subnet1a.id, aws_subnet.subnet1b.id]

  launch_template {
    id      = aws_launch_template.LT.id
    version = aws_launch_template.LT.latest_version
  }
}