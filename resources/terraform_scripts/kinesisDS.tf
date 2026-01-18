resource "aws_kinesis_stream" "clickstream" {
  name             = "${var.environment}-clickstream-data-stream"
  shard_count      = 1
  retention_period = 24
  tags = var.tags
}

resource "aws_lambda_event_source_mapping" "kds_lambda_trigger" {
  event_source_arn  = aws_kinesis_stream.clickstream.arn
  function_name     = var.lambda_function_name
  starting_position = "LATEST"
  batch_size        = 100
  enabled           = true
}