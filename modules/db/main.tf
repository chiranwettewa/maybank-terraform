resource "aws_db_instance" "mariadb_primary" {
  allocated_storage    = 20
  engine               = "mariadb"
  engine_version       = "11.4.5"
  instance_class       = "db.t2.micro"
  identifier           = "mariadb-primary"
  username = var.db_user
  password = var.db_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.sg_db]
  skip_final_snapshot  = true
  publicly_accessible  = false
}

resource "aws_db_instance" "mariadb_replica" {
  allocated_storage    = 20
  engine               = "mariadb"
  engine_version       = "11.4.5"
  instance_class       = "db.t2.micro"
  identifier           = "mariadb-replica"
  replicate_source_db  = aws_db_instance.mariadb_primary.arn
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [var.sg_db]
  depends_on = [aws_db_instance.mariadb_primary]
  skip_final_snapshot  = true
  publicly_accessible  = false
}


resource "aws_db_subnet_group" "default" {
  name       = "my-db-subnet-group"
  subnet_ids = [var.private_a_subnet_id,var.private_b_subnet_id]
}

