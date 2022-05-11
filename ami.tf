data "aws_ami" "latest-image" {
  most_recent = true
  owners      = var.ec2_owners

  filter {
    name   = "name"
    values = var.ami_attributes
  }

}