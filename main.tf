provider "aws" {
  region     = "us-east-1"
 
}


module "vpc" {
  source             = "./module/vpc"
  vpc_cidr           = var.vpc_cidr 
  client_id          = var.client_id
  env                = var.env
  public_subnets_cidr     = var.public_subnets_cidr
  private_subnets_cidr    = var.private_subnets_cidr
  availability_zones = data.aws_availability_zones.available.names
}


 module "ec2" {
  source              = "./module/ec2"
  ec2_instance_type   = "t2.micro"
  ec2_subnet_id       = module.vpc.private_subnets[0].id
  ec2_security_group_id = module.vpc.sg
  ec2_AZ  = data.aws_availability_zones.available.names[0]
  ec2_key_name        = "test"
  client_id           =  var.client_id
  root_volume_size    = "8"
  root_volume_type    = "gp3"
  ec2_tag   =" my first web server"
  
  http_response_hop_limit = "1"
  //ec2_ssm_agent_install = ""
}

module "s3" {
    source            = "./module/s3"
    s3_bucket_name   = var.s3_bucket_name      #bucket name should be unique 
}