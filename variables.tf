# Defining AWS Region
variable "aws_region" {
  description = "Region for AWS VPC"
  default     = "eu-west-2"
  type        = string
}
# Defining CIDR Block for VPC
variable "vpc_cidr" {
  description = "vpc cidr block"
  default     = "10.0.0.0/16"
  type        = string
}
# Defining CIDR Block for 1st Public Subnet
variable "pub_subnet1_cidr" {
  description = "public subnet 1 cidr block"
  default     = "10.0.1.0/24"
  type        = string
}
# Defining CIDR Block for 2nd Public Subnet
variable "pub_subnet2_cidr" {
  description = "public subnet 2 cidr block"
  default     = "10.0.2.0/24"
  type        = string
}
# Defining CIDR Block for 1st private subnet
variable "priv_subnet1_cidr" {
  description = "private subnet"
  default     = "10.0.3.0/24"
  type        = string
}
# Defining CIDR Block for 2nd Private Subnet
variable "priv_subnet2_cidr" {
  default = "10.0.4.0/24"
  type    = string
}

# Making Database username sensitive
variable "db_username" {
  description = "RDS administrator username"
  type        = string
  sensitive   = true
}
# Making Database Password sensitive
variable "db_password" {
  description = "RDS administrator password"
  type        = string
  sensitive   = true
}
#making public route table a variable
variable "aws_route_table_pub_route" {
description = "public route table"
default     = "aws_route_table.priv_route"
type        = string
}

#making private route table a variable
variable "aws_route_table_priv_route" {    
description = "private route table"
default     = "aws_route_table.priv_route"
type        = string
}