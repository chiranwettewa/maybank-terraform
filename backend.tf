terraform {
  backend "s3" {
    bucket         = "maybank-assignment"
    key            = "backend/maybank-assignment.tfstate"
    region         = "us-east-1"
    dynamodb_table = "backend"
  }
}