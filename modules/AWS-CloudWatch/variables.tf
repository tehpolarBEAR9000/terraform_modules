variable "group_name"{
    type = string
    description = "display name for cloudwatch log group"
}
variable "retention"{
    type = number
    default = 0
}
variable "tag_assignment"{
    type = map
}