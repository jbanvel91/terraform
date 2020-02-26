resource "aws_vpc" "asg_vpc" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "asg_vpc"
    Env = "${terraform.workspace}"
  }
}
