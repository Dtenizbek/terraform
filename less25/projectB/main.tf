provider "aws" {
  region = "eu-north-1"
}

module "vpc_prod" {
  # source             = "../modules/aws_network"
  source               = "git@github.com:Dtenizbek/terraform.git//aws_network"
  env                  = "prod"
  vpc_cidr             = "10.200.0.0/16"
  public_subnet_cidrs  = ["10.200.1.0/24", "10.200.2.0/24", "10.200.3.0/24"]
  private_subnet_cidrs = ["10.200.11.0/24", "10.200.22.0/24", "10.200.33.0/24"]
  tags = {
    Owner   = "TENIZBEK.NET"
    Code    = "777766"
    Project = "SuperPreject"
  }
}

module "server_standalone" {
  source = "../modules/aws_testserver"
  name      = "ADV-IT"
  message   = "Stand Alone Server"
  subnet_id = module.vpc_prod.public_subnet_ids[2]
}

module "servers_loop_count" {
  source = "../modules/aws_testserver"
  count     = length(module.vpc_prod.public_subnet_ids)
  name      = "ADV-IT"
  message   = "Hello From server in Subnet ${module.vpc_prod.public_subnet_ids[count.index]} created by COUNT Loop"
  subnet_id = module.vpc_prod.public_subnet_ids[count.index]
}

module "servers_loop_foreach" {
  source = "../modules/aws_testserver"
  for_each   = toset(module.vpc_prod.public_subnet_ids)
  name       = "ADV-IT"
  message    = "Hello From server in Subnet ${each.value} created by FOR_EACH Loop"
  subnet_id  = each.value
  depends_on = [module.servers_loop_count]
}