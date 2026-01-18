data "aws_ecr_image" "image" {
  repository_name = var.repository_name
  image_tag = var.image_tag
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "lambda_function" {
  function_name = "${var.environment}-${var.component_name}-lambda"
  image_uri     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.repository_name}@${data.aws_ecr_image.image.image_digest}"
  package_type  = "Image"
  role          = aws_iam_role.iam_role.arn
  timeout       = var.lambda_timeout
  memory_size = var.lambda_memory
  environment {
    variables = {
      REGION = var.region
      DATABASE_NAME = var.db_name
      TABLE_NAME = var.tb_name
    }
  }
  tags =  merge(var.tags, {Stage = var.environment})
}


######################IAM Roles################
resource "aws_iam_role" "iam_role" {
  name = "${var.environment}-${var.component_name}-role"
  assume_role_policy = jsonencode({
              "Version": "2012-10-17",
              "Statement": [{
                      "Effect": "Allow",
                      "Principal": {
                          "Service": [
                              "lambda.amazonaws.com"
                          ]
                      },
                      "Action": "sts:AssumeRole"
                  }
              ]
          })
}

##################IAM Policy#####################
resource "aws_iam_role_policy" "iam_policy" {
  name = "${var.environment}-${var.component_name}-policy-for-${var.region}"
  role = aws_iam_role.iam_role.name
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCloudwatchLogs",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:PutLogEvents",
                "logs:CreateLogStream"
            ],
            "Resource": ["*"]
        },
        {
            "Effect": "Allow",
            "Action": [
                "execute-api:Invoke",
                "execute-api:ManageConnections"
            ],
            "Resource": ["arn:aws:execute-api:*:*:*"]
        },
      {
        Action = [
          "timestream:*",
          "kinesis:*"
        ],
        Effect   = "Allow",
        Resource = ["*"]
      },
      {
        "Effect" : "Allow",
        "Action" : "kms:Decrypt",
        "Resource" : ["*"]
      }
    ]
})
}
