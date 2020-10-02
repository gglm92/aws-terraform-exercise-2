variable "aws_region" {
    type        = string
    description = "AWS Region"
}

variable "aws_access_key" {
    type        = string
    description = "AWS Access Key"
}

variable "aws_secret_key" {
    type        = string
    description = "AWS Secret Key"
}

variable "environment" {
    type        = string
    description = "Environment"
}

variable "key_name" {
    type        = string
    description = "Key Name"
}

variable "vpc_cidr_block" {
    type        = string
    description = "CIDR block for VPC"
}

variable "availability_zone_1" {
    type        = string
    description = "Availability zone 1"
}

variable "availability_zone_2" {
    type        = string
    description = "Availability zone 2"
}

variable "private_subnet_1_cidr_block" {
    type        = string
    description = "CIDR block for private subnet 1"
}

variable "private_subnet_2_cidr_block" {
    type        = string
    description = "CIDR block for private subnet 2"
}

variable "public_subnet_1_cidr_block" {
    type        = string
    description = "CIDR block for public subnet 1"
}

variable "public_subnet_2_cidr_block" {
    type        = string
    description = "CIDR block for public subnet 2"
}

variable "instance_ami" {
    type        = string
    description = "Amazon Machine Image"
}

variable "instance_type" {
    type        = string
    description = "EC2 instance type"
}