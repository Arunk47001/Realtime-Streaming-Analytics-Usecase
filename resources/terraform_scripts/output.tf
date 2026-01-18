output "click-stream-bucket" {
  value = aws_s3_bucket.source_bucket.bucket
}

output "click-stream-bucket-arn" {
  value = aws_s3_bucket.source_bucket.arn
}

output "click-stream-kinesis-ds-name" {
  value = aws_kinesis_stream.clickstream.name
}

output "click-stream-kinesis-ds-arn" {
  value = aws_kinesis_stream.clickstream.arn
}

output "click-stream-kinesis-firehose-name" {
  value = aws_kinesis_firehose_delivery_stream.to_s3.name
}

output "click-stream-kinesis-firehose-arn" {
  value = aws_kinesis_firehose_delivery_stream.to_s3.arn
}