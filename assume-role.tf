variable "iam_user_name" {
    default = "terraform-user"
    description = "The name of the IAM user to be created."
  
}


resource "aws_iam_role" "terraform-role" {
    name = "terraform-assumed-role"
    
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
        {
            Effect = "Allow"
            Principal = {
            AWS = "arn:aws:iam::xxxxxxxxxxxxx:root" # Or specify a user/role ARN
            }
            Action = "sts:AssumeRole"
        },
        ]
    })
    
    # Attach policies to this role to grant necessary permissions
     
  
}
data "aws_iam_policy"  "terraform_role_policy" {
  name = "AdministratorAccess"
  
  
}



resource "aws_iam_role_policy_attachments_exclusive" "terraform_role_policy_attachment" {
  role_name   = aws_iam_role.terraform-role.name
  policy_arns = [data.aws_iam_policy.terraform_role_policy.arn]
}

output "terrraform_role_arn" {
  value = aws_iam_role.terraform-role.arn
  description = "The ARN of the IAM role"
  #sensitive = true
  
}

data "aws_iam_role" "attched_policy" {
  name = aws_iam_role.terraform-role.name

}

output "role_policy" {
    value = data.aws_iam_role.attched_policy.assume_role_policy
    description = "The ARN of the IAM role"
  
}


#Create user to assume the role and attache assume role policy
resource "aws_iam_user" "terraform_user" {
  name = "${var.iam_user_name}"
  path = "/terraform/"
}


# Create IAM assume role policy for user
resource "aws_iam_policy" "assume_role_policy" {
  name        = "${var.iam_user_name}-assume-role-policy"
  description = "Allows the Terraform user to assume a specific role."

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Resource =  aws_iam_role.terraform-role.arn # Granting permission to assume the specified role ARN
      },
    ],
  })
}



resource "aws_iam_user_policy_attachment" "attach_assume_role_policy" {
  user       = aws_iam_user.terraform_user.name
  policy_arn = aws_iam_policy.assume_role_policy.arn
}
output "user_name" {
  value = aws_iam_user.terraform_user.name
  description = "The name of the IAM user"
  #sensitive = true
  
}