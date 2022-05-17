module "vpc" {
  source = "../modules/vpc"
  env_name = var.env_name
  cidr_prefix = var.cidr_prefix
  region = var.aws_region

  enable_nat_gateway = true
  target_ips_demand_fixed_ip = var.target_ips_demand_fixed_ip

}

output "vpc_id" {
  value = module.vpc.vpc_id
}