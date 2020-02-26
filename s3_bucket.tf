resource "aws_s3_bucket" "tf_bucket" {
  bucket = "${var.bucketname}"
  acl    = "private"
  region = "${var.region}"

  tags = {
    Name        = "tf_bucket"
    Environment = "${terraform.workspace}"
  }
}
