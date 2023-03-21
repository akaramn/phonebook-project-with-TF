resource "aws_db_subnet_group" "db-sub-grp" {
  name       = "main"
  subnet_ids = [aws_subnet.subnet1a.id, aws_subnet.subnet1b.id]

  tags = {
    Name = "Phonebook DB subnet group"
  }
}


resource "aws_db_instance" "RDS" {
  allocated_storage           = 20
  db_name                     = "phonebook"
  engine                      = "mysql"
  engine_version              = "8.0.28"
  instance_class              = "db.t3.micro"
  username                    = "admin"
  password                    = "Akaraman_1"
  monitoring_interval         = 0
  multi_az                    = false
  publicly_accessible         = false
  port                        = 3306
  skip_final_snapshot         = true
  availability_zone           = "us-east-1a"
  identifier                  = "phonebook-app-db"
  db_subnet_group_name        = aws_db_subnet_group.db-sub-grp.id
  vpc_security_group_ids      = [aws_security_group.RDS-sec-grp.id]
  allow_major_version_upgrade = false
  auto_minor_version_upgrade  = true
  backup_retention_period     = 0
}