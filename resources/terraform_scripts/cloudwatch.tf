resource "aws_cloudwatch_log_group" "firehose_log_group" {
  name = "/aws/kinesisfirehose/${var.environment}-clickstream"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "firehose_log_stream" {
  name           = "${var.environment}-firehose-errors"
  log_group_name = aws_cloudwatch_log_group.firehose_log_group.name
}
