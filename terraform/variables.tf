variable "profile" {
  type    = string
  default = "default"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "code_version" {
  description = "Version that gives the git repo commit ID when the terraform was applied."
  type        = string
}

variable "environment" {
  description = "Environment associated with this network configuration."
  type        = string
  default     = "prod"
}

variable "network_cidr" {
  description = "The network CIDR, this will be used in the VPC configuration."
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets configuration, in these subnets we have ENIs with public addressing."
  type        = list(any)
  default     = ["10.0.128.0/24", "10.0.129.0/24"]
}

variable "domain_name" {
  description = "The network main domain, this should be the top level domain only, the configuration will add further subdomains as described in confluence IT / Feedzai IT Cloud."
  type        = string
  default     = "bidnamic.com"
}

variable "bidnamic_network" {
  description = "Bidnamic network CIDR."
  default     = ["0.0.0.0/0"]
}

variable "instance-type" {
  type    = string
  default = "t3.micro"
}
