terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 5.95.0"
        }
    }
    required_version = "~> 1.11.0"
}

provider "aws" {
    region = "us-west-2"
    # assume_role {
    #     role_arn = "arn:aws:iam::xxxxxxxxxx:role/terraform-assumed-role"
    #     session_name = "TerraformSession"
    # }
}


# resource "aws_iam_role" "terraform_assumed_role" {
#   name = "terraform-assumed-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::xxxxxxxxxx:root" # Or specify a user/role ARN
#         }
#         Action = "sts:AssumeRole"
#       },
#     ]
#   })

#   # Attach policies to this role to grant necessary permissions
# }