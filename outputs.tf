output "service_subnet_a_id" {
  value = aws_subnet.a.id
}

output "service_subnet_b_id" {
  value = aws_subnet.b.id
}

output "service_subnet_c_id" {
  value = aws_subnet.c.id
}

output "vpc_id" {
  value = aws_vpc.default.id
}

output "nat_gateway_ip" {
  value = aws_eip.nat_gateway[*].public_ip
}
