resource "aws_db_instance" "asg_rds" {
    identifier = "asg-rds-${terraform.workspace}"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "Qwerty123"
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = "${aws_db_subnet_group.asg_rds.name}"
  backup_window        = "15:00-15:30"
  auto_minor_version_upgrade = false
}
resource "aws_db_subnet_group" "asg_rds" {
  name       = "asg_rds_sub"
  subnet_ids = "${aws_subnet.asg_pr_sn.*.id}"

  tags = {
    Name = "asg_rds_pr_subnet group"
  }
}
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow sql port"
  vpc_id      = "${aws_vpc.asg_vpc.id}"
  
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web_sg.id}"]
  }
   egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
