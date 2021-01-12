variable "name" {
  description = "Name for vpc enviroment"
  type        = string
}

variable "cidr_vpc" {
  description = "cidr block"
  type        = string
}

variable "azs" {
  description = "Availability zones for subnet deployment"
  type        = list(string)
}

variable "cidr_public" {
  description = "cidrs for public subnets"
  type        = list(string)
}

variable "cidr_private" {
  description = "cidrs for private subnets"
  type        = list(string)
}

variable "enable_nat_gateway"{
  type        = string
}   
variable "single_nat_gateway"{
  type        = string
}   
variable "enable_dns_hostnames"{
  type        = string
} 
variable "private_subnet_tags"{
  type        = map(string)
}
variable "public_subnet_tags"{
  type        = map(string)
}
variable "tags"{
  type        = map(string)
}
