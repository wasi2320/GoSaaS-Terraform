
resource "aws_instance" "my_server" {
  ami                         = data.aws_ami.amazon-linux2.id 
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.ec2_subnet_id
  vpc_security_group_ids      = [var.ec2_security_group_id]
  availability_zone           = var.ec2_AZ
  key_name                    = aws_key_pair.generated_key.key_name
  user_data                   = file("./openvpn.sh")
  iam_instance_profile        = aws_iam_instance_profile.iam-profile-for-ssm-agent.name
  //disable_api_termination     =  true
  //add delete_on_termination protection here
  root_block_device {
    volume_size               = var.root_volume_size
    volume_type               = var.root_volume_type
    delete_on_termination     = true
    encrypted                 = true                                    #[EC2.3] Attached EBS volumes should be encrypted at rest
  }
  metadata_options {                                                    #[EC2.8] EC2 instances should use IMDSv2
        http_tokens                 = "required"                        #ref: https://registry.terraform.io/providers/hashicorp/aws/3.65.0/docs/resources/instance#http_endpoint
        http_endpoint               = "enabled"
        http_put_response_hop_limit = var.http_response_hop_limit
    }
  tags={
      Name: "${var.ec2_tag}"
  }
}

#######################################Adding role for Enabling session manger########################################


#created a IAM role here and attache ec2-profile to it


resource "aws_iam_instance_profile" "iam-profile-for-ssm-agent" {
name = "ec2_profile"   
role = aws_iam_role.iam-profile-for-ssm-agent-role.name
}

resource "aws_iam_role" "iam-profile-for-ssm-agent-role" {
name        = "ssm-role"
description = "The role for the resources to access EC2 through session manager"
assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": {
"Effect": "Allow",
"Principal": {"Service": "ec2.amazonaws.com"},
"Action": "sts:AssumeRole"
}
}
EOF
tags = {
stack = "test-ssm-role"
}
}

resource "aws_iam_role_policy_attachment" "ssm-policy" {
role       = aws_iam_role.iam-profile-for-ssm-agent-role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}