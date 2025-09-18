module "vpc" {
  source= "./modules/vpc"
  aws_region = var.aws_region
  vpc_cidr = var.vpc_cidr
  public_subnet_a_cidr = var.public_subnet_a_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  public_subnet_b_cidr = var.public_subnet_b_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr

}

module "sg" {
  source= "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "db" {

  source = "./modules/db"

  db_password = var.db_password
  db_user = var.db_user
  private_a_subnet_id = module.vpc.private_subnet_a
  private_b_subnet_id = module.vpc.private_subnet_b
  sg_db = module.sg.sg_db

}

module "nlb" {

  source = "./modules/nlb"
  
  public_subnet_b_id = module.vpc.public_subnet_b
  public_subnet_a_id = module.vpc.public_subnet_a
  vpc_id = module.vpc.vpc_id
}


module "ec2" {
  source = "./modules/ec2"
  private_subnet_a_id = module.vpc.private_subnet_a
  private_subnet_b_id =module.vpc.private_subnet_b
  public_subnet_b_id= module.vpc.public_subnet_b
  public_subnet_a_id = module.vpc.public_subnet_a
  nlb_tg = module.nlb.nlb_tg
  sg_ssm = module.sg.sg_ssm
  sg_ec2 = module.sg.sg_ec2
}

module "cloudfront" {
  source = "./modules/cloudfront"

  s3_bucket = module.s3.s3_bucket

}

module "s3" {
  source = "./modules/s3"

  s3_bucket = var.s3_bucket  
}

module "vpc-endpoints" {
  source = "./modules/vpc-endpoints"
  sg_ssm = module.sg.sg_ssm
  private_subnet_a_id = module.vpc.private_subnet_a
  private_subnet_b_id = module.vpc.private_subnet_b
  aws_region = var.aws_region
  vpc_id = module.vpc.vpc_id

}
