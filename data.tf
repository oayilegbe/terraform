# use data source to get the latest version of the amazon linux ami

data "aws_ami" "amzn2" {
  most_recent = true
  owners = ["amazon"]

  # filter {
  #   name   = "name"
  #   values = ["amzn2-ami-hvm.*"]
  # }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
   filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
