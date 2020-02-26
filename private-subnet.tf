resource "aws_subnet" "asg_pr_sn" {
    count = "${length(slice(local.az_names,0,2))}"
    vpc_id     = "${aws_vpc.asg_vpc.id}"
    cidr_block = "${cidrsubnet(var.vpc_cidr, 4, count.index + length(local.az_names))}"
    availability_zone = "${local.az_names[count.index]}"
    tags = {
        Name = "asg_pr_sn-${count.index + 1}"
    }
}
resource "aws_security_group" "asg_nat_sg" {
  name        = "asg_nat_sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = "${aws_vpc.asg_vpc.id}"

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
