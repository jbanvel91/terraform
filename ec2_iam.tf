data "template_file" "s3_iam_policy" {
  template = "${file("/home/ubuntu/new_vpc/scripts/s3_ec2_policy.json")}"
  vars = {
    tf_bucket_arn = "arn:aws:s3:::${var.bucketname}/*"
  }
}

resource "aws_iam_role_policy" "s3_ec2_role_policy" {
  name = "test_policy"
  role = "${aws_iam_role.s3_ec2_role.id}"

  policy = "${data.template_file.s3_iam_policy.rendered}"
}

resource "aws_iam_role" "s3_ec2_role" {
  name = "s3_ec2_role"

  assume_role_policy = "${file("/home/ubuntu/new_vpc/scripts/ec2_role.json")}"
}
#instance profile to attach the role in ec2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = "${aws_iam_role.s3_ec2_role.name}"
}


