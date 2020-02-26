variable "vpc_cidr" {
  type = "string"
  default = "11.0.0.0/16"
}

variable "region" {
  type    = "string"
  default = "ap-southeast-1"
}
variable "ami" {
  type = "map"
  default = {
    ap-southeast-1 = "ami-0012a981fe3b8891f"
  }
}
variable "web_tags" {
  type = "map"
  default={
    Name = "webserver"
  }
}
variable "web_ins_type" {
  default = "t2.micro"
}
variable "web_ami" {
  type = "map"
  default = {
    ap-southeast-1 = "ami-05c64f7b4062b0a21"
  }
}
variable "web_server_no" {
   default = "2"
}
variable "bucketname" {
  default = "waganor800b"
}

