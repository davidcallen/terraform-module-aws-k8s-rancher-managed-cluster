# Use latest SLES 15 SP3
data "aws_ami" "sles" {
  most_recent = true
  owners      = ["013907871322"] # SUSE
  filter {
    name   = "name"
    values = ["suse-sles-15-sp3*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/*/ubuntu-focal-20.04-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "windows" {
  most_recent = true
  owners      = ["801119661308"] #Amazon
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-ContainersLatest-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}