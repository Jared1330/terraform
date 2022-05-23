provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}



terraform {
  backend "s3" {
    bucket = "ruslan123-terraform-state"
    key    = "states/terraform.tfstate"
    region = "us-east-1"
  }
}


