variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type = string
  default = "192.168.0.0/16"
}

variable "public_subnet_a_cidr" {
  type = string
  default = "192.168.8.0/24"
}

variable "private_subnet_a_cidr" {
  type = string
  default = "192.168.16.0/24"
}

variable "public_subnet_b_cidr" {
  type = string
  default = "192.168.32.0/24"
}

variable "private_subnet_b_cidr" {
  type = string
  default = "192.168.64.0/24"
}

variable "s3_bucket" {
  type = string
  default = "maybank-assignment-bucket"
}

variable "db_user"{
  type = string
  default = "user"
}

variable "db_password"{
  type = string
  default = "wefa212dss12"
}

