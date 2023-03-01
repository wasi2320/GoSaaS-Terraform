
# Get latest Ubuntu Linux Bionic 18.04 AMI
data "aws_ami" "ubuntu-1804" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name      = "name"
    values    = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name      = "virtualization-type"
    values    = ["hvm"]
  }
}

# Get latest Ubuntu Linux Disco 20.04 AMI
data "aws_ami" "ubuntu-2004" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name      = "name"
    values    = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name      = "virtualization-type"
    values    = ["hvm"]
  }
}

# Get latest Amazon Linux2 AMI
data "aws_ami" "amazon-linux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name      = "name"
    values    = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name      = "virtualization-type"
    values    = ["hvm"]
  }
}