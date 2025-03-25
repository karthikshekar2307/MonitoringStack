terraform {
  backend "s3" {
    bucket         = "tfstate-monitoring-dev"
    key            = "non-prod/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "tf-lock-monitoring-dev"
    encrypt        = true
  }
}
