vpc_name = "monitoring-vpc-nonprod"
vpc_cidr = "10.10.0.0/16"
azs = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
public_subnets = ["10.10.0.0/20", "10.10.16.0/20", "10.10.32.0/20"]
private_subnets = ["10.10.48.0/20", "10.10.64.0/20", "10.10.80.0/20"]

tags = {
  Environment = "non-prod"
  Project     = "Monitoring"
}
