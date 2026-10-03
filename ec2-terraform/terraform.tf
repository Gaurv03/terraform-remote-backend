terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "vinter-state-bucket"
    key = "terraform.tfstate"
    region = "us-east-1"
    # dynamodb_table = "vinter-state-table"  #old way
    use_lockfile = true
  }
}
