# VPC
vpc_name   = "infra-vpc"
cidr_block = "10.0.0.0/16"
region = "us-east-1"

# Subnets
subnet_name     = "infra-subnet"
azs             = ["us-east-1a", "us-east-1b"]
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.6.0/24", "10.0.10.0/24"]
subnet_group_name = "infra-subnet-private"

# NAT Gateway
nat_name = "infra-nat-gateway"

# Internet Gateway
igw_name = "infra-igw"

# Route Table
route_table_name = "infra-public-route-table"
route_cidr = "0.0.0.0/0"

# Security Groups
sg_api_name      = "infra-sg-api"

# ACL
acl_name = "infra-acl"

# Tags
tags = {
  Owner = "nexTime-frame"
}