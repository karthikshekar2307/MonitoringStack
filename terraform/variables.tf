variable "vpc_name" {
  default = "monitoring-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "azs" {
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "public_subnets" {
  default = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
}

variable "private_subnets" {
  default = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
}

variable "tags" {
  default = {
    Project     = "Monitoring"
    Environment = "Dev"
  }
}
