data "aws_route53_zone" "asg_r53" {
  name         = "banuvel.xyz."
  private_zone = false
}
resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.asg_r53.zone_id}"
  name    = "${data.aws_route53_zone.asg_r53.name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.asg_elb.dns_name}"
    zone_id                = "${aws_elb.asg_elb.zone_id}"
    evaluate_target_health = true
  }
}
