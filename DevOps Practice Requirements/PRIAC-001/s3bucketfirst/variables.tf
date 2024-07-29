variable "region" {
  description = "tims AWS region"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones_count" {
  description = "The number of AZs."
  type        = number
  default     = 2
}

variable "project" {
  description = "tims-lower-environments"
  type    = string
  default = "tims-lower-environments"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.1.0.0/21"
}

variable "subnet_cidr_bits" {
  description = "The number of subnet bits for the CIDR. For example, specifying a value 8 for this parameter will create a CIDR with a mask of /24."
  type        = number
  default     = 8
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Project"     = "Dev-tims"
    "Environment" = "Development"
    "Owner"       = "tims_Terraform"
  }
}
