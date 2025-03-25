terraform {
  backend "s3" {
    bucket         = "tfstate-monitoring-dev"
    key            = "prod/terraform.tfstate"
    region         = "aps-outheast-2"
    dynamodb_table = "tf-lock-monitoring-dev"
    encrypt        = true
  }
}
