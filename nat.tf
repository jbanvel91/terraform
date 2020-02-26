resource "aws_instance" "test" {
  ami           = "${var.ami[var.region]}"
  subnet_id     = "${aws_subnet.asg_pb_sn.*.id[0]}"
  instance_type = "t2.micro"
  source_dest_check = "false"
  vpc_security_group_ids = ["${aws_security_group.asg_nat_sg.id}"]
  tags = {
        Name = "test_ec2"
    }
}
resource "aws_route_table" "pr_rt" {
  vpc_id = "${aws_vpc.asg_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    instance_id  = "${aws_instance.test.id}"
  }
  tags = {
    Name = "pr_rt"
  }
}
resource "aws_route_table_association" "pr_rt_sb_ass" {
  count          = "${length(slice(local.az_names,0,2))}"
  subnet_id      = "${aws_subnet.asg_pr_sn.*.id[count.index]}"
  route_table_id = "${aws_route_table.pr_rt.id}"
}
