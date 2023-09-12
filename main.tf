resource "aws_vpc" "default" {
  cidr_block              = "${var.cidr_prefix}.0.0/16"
  enable_dns_hostnames    = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id
}

resource "aws_subnet" "nat" {
  count = var.enable_nat_gateway ? 1 : 0
  vpc_id                        = aws_vpc.default.id
  cidr_block                    = "${var.cidr_prefix}.0.0/24"
  map_public_ip_on_launch       = true
  availability_zone             = "${var.region}a"

  tags = {
    Status = "created by TF"
    Name = "${var.env_name} - subnet nat"
  }
}

resource "aws_subnet" "a" {
  vpc_id                        = aws_vpc.default.id
  cidr_block                    = "${var.cidr_prefix}.1.0/24"
  map_public_ip_on_launch       = true
  availability_zone             = "${var.region}a"

  tags = {
    Status = "created by TF"
    Name = "${var.env_name} - subnet A"
    Ecs = "true"
  }
}

resource "aws_subnet" "b" {
  vpc_id                        = aws_vpc.default.id
  cidr_block                    = "${var.cidr_prefix}.2.0/24"
  map_public_ip_on_launch       = true
  availability_zone             = "${var.region}b"

  tags = {
    Status = "created by TF"
    Name = "${var.env_name} - subnet B"
    Ecs = "true"
  }
}

resource "aws_subnet" "c" {
  vpc_id                        = aws_vpc.default.id
  cidr_block                    = "${var.cidr_prefix}.3.0/24"
  map_public_ip_on_launch       = true
  availability_zone             = "${var.region}c"

  tags = {
    Status = "created by TF"
    Name = "${var.env_name} - subnet C"
    Ecs = "true"
  }
}


resource "aws_eip" "nat_gateway" {
  count = var.enable_nat_gateway ? 1 : 0
  domain  = "vpc"
}

resource "aws_nat_gateway" "nat_gateway" {
  count = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_gateway[0].id
  subnet_id = aws_subnet.nat[0].id
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.default.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    dynamic "route" {
      for_each = toset(var.target_ips_demand_fixed_ip)
      content {
        cidr_block = route.value
        nat_gateway_id = aws_nat_gateway.nat_gateway[0].id
      } 
    }


}

resource "aws_route_table" "nat" {
  count = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.default.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
  }

}

resource "aws_route_table_association" "route_table_association_nat" {
  count = var.enable_nat_gateway ? 1 : 0
  subnet_id      = aws_subnet.nat[0].id
  route_table_id = aws_route_table.nat[0].id
}

resource "aws_route_table_association" "route_table_association_a" {
    subnet_id      = aws_subnet.a.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "route_table_association_b" {
    subnet_id      = aws_subnet.b.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "route_table_association_c" {
    subnet_id      = aws_subnet.c.id
    route_table_id = aws_route_table.public.id
}

