resource "aws_cloudwatch_log_group" "CWL_Group_Name"{
    tags = var.tag_assignment
    name = var.group_name
    retention_in_days = var.retention
}