module "vpc" {
  source     = "./modules/vpc"
  vpc_name   = var.vpc_name
  cidr_block = var.cidr_block
  tags       = var.tags
}

module "private_subnet" {
  source            = "./modules/subnet/private_subnet"
  subnet_name       = var.subnet_name
  vpc_id            = module.vpc.vpc_id
  azs               = var.azs
  private_subnets   = var.private_subnets
  subnet_group_name = var.subnet_group_name
  tags              = var.tags
}

module "public_subnet" {
  source         = "./modules/subnet/public_subnet"
  subnet_name    = var.subnet_name
  vpc_id         = module.vpc.vpc_id
  azs            = var.azs
  public_subnets = var.public_subnets
  tags           = var.tags
}

module "internet_gateway" {
  source   = "./modules/internet_gateway"
  igw_name = var.igw_name
  vpc_id   = module.vpc.vpc_id
  tags     = var.tags
}

module "nat_gateway" {
  source           = "./modules/nat_gateway"
  nat_name         = var.nat_name
  public_subnet_id = module.public_subnet.public_subnet_ids[0]
  tags             = var.tags
}

module "route_table" {
  source           = "./modules/route_table"
  route_table_name = var.route_table_name
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.public_subnet.public_subnet_ids
  gateway_id       = module.internet_gateway.igw_id
  route_cidr       = var.route_cidr
  tags             = var.tags
}

module "security_group_api" {
  source      = "./modules/security_group/public_sg"
  sg_api_name = var.sg_api_name
  vpc_id      = module.vpc.vpc_id
  tags        = var.tags
}

# 🔹 ACL
module "acl" {
  source    = "./modules/acl"
  acl_name  = var.acl_name
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.public_subnet.public_subnet_ids[0]
  tags      = var.tags
}

# 🔹 ECR Repositories for microservices
module "ecr" {
  source = "./modules/ecr"

  repository_names     = ["ms-video", "process-video"]
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
  tags                 = var.tags
}

# 🔹 Security Group for ECS tasks (referenced by DocumentDB module)
resource "aws_security_group" "ecs_tasks" {
  name        = "nextime-ecs-tasks-sg"
  description = "Security group for ECS Fargate tasks"
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "nextime-ecs-tasks-sg" }, var.tags)
}

# 🔹 DocumentDB (MongoDB-compatible)
module "documentdb" {
  source = "./modules/documentdb"

  cluster_identifier        = var.docdb_cluster_identifier
  master_username           = var.docdb_master_username
  master_password           = var.docdb_master_password
  instance_class            = var.docdb_instance_class
  instance_count            = var.docdb_instance_count
  subnet_ids                = module.private_subnet.private_subnet_ids
  vpc_id                    = module.vpc.vpc_id
  allowed_security_group_id = aws_security_group.ecs_tasks.id
  tags                      = var.tags
}