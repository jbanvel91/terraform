locals {
  az_names = "${data.aws_availability_zones.asg_azs.names}"
}
resource "aws_subnet" "asg_pb_sn" {
    count = "${length(local.az_names)}"
    vpc_id     = "${aws_vpc.asg_vpc.id}"
    cidr_block = "${cidrsubnet(var.vpc_cidr, 4, count.index)}"
    availability_zone = "${local.az_names[count.index]}"
    map_public_ip_on_launch = true
    tags = {
        Name = "asg_pb_sn-${count.index + 1}"
  }
}
resource "aws_internet_gateway" "asg_igw" {
  vpc_id = "${aws_vpc.asg_vpc.id}"

  tags = {
    Name = "asg_igw"
  }
}
resource "aws_route_table" "pub_rt" {
  vpc_id = "${aws_vpc.asg_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.asg_igw.id}"
  }

  tags = {
    Name = "pub_rt"
  }
}

resource "aws_route_table_association" "pub_rt_sb_ass" {
  count          = "${length(local.az_names)}"
  subnet_id      = "${aws_subnet.asg_pb_sn.*.id[count.index]}"
  route_table_id = "${aws_route_table.pub_rt.id}"
}
