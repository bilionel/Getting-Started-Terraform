variable "aws_access_key" {
    type = string
    description = "AWS Access Key"
    sensitive = true
}

variable "aws_secret_key" {
    type = string
    description = "AWS Secret Key"
    sensitive = true
}

variable "aws_region" {
    type = string
    description = "AWS Region to use for resources"
    default = "eu-west-1"
}

variable "vpc_cidr_block" {
    type = string
    description = "VPC CIDR block"
    default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type = bool
    description = "AWS enable DNS hostnames"
    default = true
}

variable "vpc_subnets_cidr_block" {
    type = list(string)
    description = "cidr block for subnets in the VPC"
    default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "map_public_ip_on_launch" {
    type = bool
    description = "map a public IP address for subnet instance"
    default = true
}

variable "aws_instance_type" {
    type = string
    description = "AWS instance type"
    default = "t2.micro"
}

variable "company" {
    type = string
    description = "name of the company for resource tagging"
    default = "Globomantics"
}

variable "project" {
    type = string
    description = "name of the project for resource tagging"
}

variable "billing_code" {
    type = string
    description = "billing code for for resource tagging"
}