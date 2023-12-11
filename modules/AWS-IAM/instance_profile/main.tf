resource "aws_iam_instance_profile" "label_profile" {
  name = var.instance_profile_info.name
  role = var.instance_profile_info.role
}