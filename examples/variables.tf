variable "aws_region" {
  default = "us-east-1"
}

variable "env_name" {
  default = "stage"
}

variable "cidr_prefix" {
  default = "10.0"
}

variable "target_ips_demand_fixed_ip" {
  default = ["1.1.1.1/32", "8.8.8.8/32"]
}