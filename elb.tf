resource "aws_elb" "asg_elb" {
  name               = "asg-elb-${terraform.workspace}"
  #availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
    subnets = "${aws_subnet.asg_pb_sn.*.id}"
    security_groups = "${aws_security_group.elb_sg.*.id}"
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  instances                   = "${aws_instance.web.*.id}"
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "asg-elb-${terraform.workspace}"
  }
}
resource "aws_security_group" "elb_sg" {
  name        = "elb_sg"
  description = "Allow web server port"
  vpc_id      = "${aws_vpc.asg_vpc.id}"
  
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}
