# Define base tags
locals {
  base_tags = {
    Name        = format("%s - %s", upper(var.environment), var.code_version)
    Environment = upper(var.environment)
    Version     = var.code_version
  }
}

data "aws_caller_identity" "current" {}

# Configure DHCP options
resource "aws_vpc_dhcp_options" "dhcp-opt" {
  domain_name_servers = ["AmazonProvidedDNS"]
  domain_name         = var.domain_name

  tags = local.base_tags
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.network_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = local.base_tags
}

# Attach DHCP option set to the VPC
resource "aws_vpc_dhcp_options_association" "dhcp" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp-opt.id
}

# Internet Gateway to be able to reach external hosts
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = local.base_tags
}

#Get all available AZ's
data "aws_availability_zones" "azs" {
  state = "available"
}

# Create the public subnets.
resource "aws_subnet" "public_az1" {

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnets[0]
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  tags = {
    Name        = format("%s - %s - %s", "public_az1", upper(var.environment), var.code_version)
    Environment = upper(var.environment)
    Version     = var.code_version
  }
}

resource "aws_subnet" "public_az2" {

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnets[1]
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  tags = {
    Name        = format("%s - %s - %s", "public_az2", upper(var.environment), var.code_version)
    Environment = upper(var.environment)
    Version     = var.code_version
  }
}

# Allocate a route table for the public subnets.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = format("%s - %s - %s", "public", upper(var.environment), var.code_version)
    Environment = upper(var.environment)
    Version     = var.code_version
  }

  # Add route for the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associate the same routing table (public) to both subnets of different availability zones.
resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}
