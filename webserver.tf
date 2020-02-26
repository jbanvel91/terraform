locals {
  en_tag={
      Environment = "${terraform.workspace}"
  }
#to merge
    web_tags = "${merge(var.web_tags, local.en_tag)}"
}
resource "aws_instance" "web" {
    count         = "${var.web_server_no}"
    ami           = "${var.web_ami[var.region]}"
    instance_type = "${var.web_ins_type}"
    subnet_id     = "${aws_subnet.asg_pb_sn.*.id[count.index]}"
    user_data     = "${file("/home/ubuntu/new_vpc/scripts/apache.sh")}"
    iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
    vpc_security_group_ids = ["${aws_security_group.web_sg.id}"]
    key_name = "${aws_key_pair.web_key.key_name}"
    tags = "${local.web_tags}"
}
resource "aws_key_pair" "web_key" {
  key_name   = "web_key"
  public_key = "${file("/home/ubuntu/new_vpc/scripts/web_pub.key")}"
}
