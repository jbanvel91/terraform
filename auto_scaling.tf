resource "aws_launch_configuration" "asg_lan_con" {
  name          = "asg_lan_con"
  image_id      = "${var.ami[var.region]}"
  key_name      = "${aws_key_pair.web_key.key_name}"
  user_data     = "${file("/home/ubuntu/new_vpc/scripts/apache.sh")}"
  iam_instance_profile = "${aws_iam_instance_profile.ec2_profile.name}"
  security_groups = ["${aws_security_group.web_sg.id}"]
  instance_type = "t2.micro"
}
resource "aws_autoscaling_group" "asg_grp" {
  name                 = "asg_grp"
  launch_configuration = "${aws_launch_configuration.asg_lan_con.name}"
  min_size             = 1
  max_size             = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  vpc_zone_identifier       = "${aws_subnet.asg_pb_sn.*.id}"
  load_balancers = ["${aws_elb.asg_elb.name}"]
  lifecycle {
    create_before_destroy = true
  }
  tags = [
    {
      key                 = "explicit1"
      value               = "value1"
      propagate_at_launch = true
    },
    {
      key                 = "explicit2"
      value               = "value2"
      propagate_at_launch = true
    },
  ]
}
resource "aws_autoscaling_policy" "asg_add_policy" {
  name                   = "asg_add_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.asg_grp.name}"
}
resource "aws_autoscaling_policy" "asg_rm_policy" {
  name                   = "asg_rm_policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.asg_grp.name}"
}
resource "aws_cloudwatch_metric_alarm" "asg_cpu_alarm_80" {
  alarm_name                = "asg_cpu_alarm_80"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.asg_grp.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.asg_add_policy.arn}"]
}
resource "aws_cloudwatch_metric_alarm" "asg_cpu_alarm_30" {
  alarm_name                = "asg_cpu_alarm_30"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "30"
  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.asg_grp.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.asg_rm_policy.arn}"]
}
