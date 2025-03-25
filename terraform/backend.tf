terraform {
  backend "s3" {
    bucket         = "tfstatemoneksbucket"
    key            = "eks/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "tf-lock-monitoring-dev"
    encrypt        = true
  }
}
