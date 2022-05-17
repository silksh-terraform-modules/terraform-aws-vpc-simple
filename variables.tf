variable "cidr_prefix" {
  default = "10.0"
}

variable "env_name" {
  default = ""
}

variable "region" {
  default = ""
}

variable "enable_nat_gateway" {
  default = false
}

variable "target_ips_demand_fixed_ip" {
  default = []
  description = "targets list which demand fixed outbount IP for ex. for security reasons"
}