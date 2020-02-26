resource "aws_lb_target_group" "asg_alb_tg" {
  name     = "asg-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.asg_vpc.id}"
}
resource "aws_lb_target_group_attachment" "asg_alb_att" {
    count = "${var.web_server_no}"
  target_group_arn = "${aws_lb_target_group.asg_alb_tg.arn}"
  target_id        = "${aws_instance.web.*.id[count.index]}"
  port             = 80
}
resource "aws_lb" "asg-alb" {
  name               = "asg-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.elb_sg.id}"]
  subnets            = "${aws_subnet.asg_pb_sn.*.id}"

  tags = {
    Environment = "ASG-alb-${terraform.workspace}"
  }
}
resource "aws_lb_listener" "asg_lb_listener" {
  load_balancer_arn = "${aws_lb.asg-alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.asg_alb_tg.arn}"
  }
}
