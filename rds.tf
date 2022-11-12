# Creating RDS Instance
resource "aws_db_subnet_group" "default" {
  name       = var.aws_db_subnet_group_default
  subnet_ids = ["${aws_subnet.priv_subnet_1.id}", "${aws_subnet.priv_subnet_2.id}"]

  tags = {
    Name = var.tags[0]
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.default.id
  engine                 = "mysql"
  engine_version         = "8.0.20"
  instance_class         = "db.t2.micro"
  multi_az               = true
  name                   = "mydb"
  username               = var.db_username
  password               = var.db_password
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.database-sg.id]
  publicly_accessible    = false
}