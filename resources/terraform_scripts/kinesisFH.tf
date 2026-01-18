resource "aws_kinesis_firehose_delivery_stream" "to_s3" {
  name        = "${var.environment}-clickstream-firehose"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = aws_s3_bucket.source_bucket.arn
    buffering_interval = 60
    compression_format = "GZIP"
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.firehose_log_group.name
      log_stream_name = aws_cloudwatch_log_stream.firehose_log_stream.name
    }
  }

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.clickstream.arn
    role_arn           = aws_iam_role.firehose_role.arn
  }
  tags = var.tags
}

resource "aws_iam_role" "firehose_role" {
  name = "${var.environment}_clickstream_firehose_delivery_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "firehose.amazonaws.com"
      },
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role_policy" "firehose_policy" {
  name = "${var.environment}_clickstream_firehose_s3_policy"
  role = aws_iam_role.firehose_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = [
          aws_s3_bucket.source_bucket.arn,
          "${aws_s3_bucket.source_bucket.arn}/*"
        ]
      },
      {
      "Effect": "Allow",
      "Action": [
        "kinesis:DescribeStream",
        "kinesis:GetShardIterator",
        "kinesis:GetRecords"
      ],
      "Resource": [aws_kinesis_stream.clickstream.arn]
    }
    ]
  })
}