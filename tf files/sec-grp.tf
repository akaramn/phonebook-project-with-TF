resource "aws_security_group" "ALB-sec-grp" {
  name        = "ALB-sec-grp"
  description = "allows HTTP inbound traffic"
  vpc_id      = aws_vpc.phonebook-vpc.id


  ingress {
    description = "HTTP from Anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB-sec-grp"
  }
}



resource "aws_security_group" "ec2-sec-grp" {
  name        = "ec2-sec-grp"
  description = "allows SSH and  HTTP inbound traffic"
  vpc_id      = aws_vpc.phonebook-vpc.id

  ingress {
    description = "SSH from Anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ALB-sec-grp.id]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "ec2-sec-grp"
  }
}


resource "aws_security_group" "RDS-sec-grp" {
  name        = "RDS-sec-grp"
  description = "allows 3306 inbound traffic"
  vpc_id      = aws_vpc.phonebook-vpc.id


  ingress {
    description     = "allows 3306 from ec2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2-sec-grp.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS-sec-grp"
  }
}
