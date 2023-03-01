variable "client_id" {}

variable "region" {
  type = string
}


variable "vpc_cidr" {
  type = string
}

variable "env" {
  type = string
}

variable "public_subnets_cidr" {
  type = list(string)
}

variable "private_subnets_cidr" {
  type = list(string)
}

variable "s3_bucket_name" {}

