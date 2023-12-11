output "cloudwatch_log_group_resource" {
    value = aws_cloudwatch_log_group.CWL_Group_Name.arn
}