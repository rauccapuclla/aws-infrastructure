resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/ecs/app"
  retention_in_days = 7

  tags {
    Name = "app-log-group"
  }
}

resource "aws_cloudwatch_log_stream" "app_log_stream" {
  name           = "app-log-stream"
  log_group_name = "${aws_cloudwatch_log_group.log_group.name}"
}
