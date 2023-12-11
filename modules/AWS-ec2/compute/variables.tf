variable "ami_filter"{
    description = "display name for cloudwatch log group"
    type = object(
        {
            most_recent = bool 
            filter_name = string
            filter_values = list(string)
        }
    )
}
variable "root_block_storage"{
    type = object(
            {
                #name = string
                encrypted = bool
                volume_size = number
                volume_type = string
                delete_on_termination = bool   
            }
        )
}
variable "ebs_block_storage"{
    type = list(object(
            {
                device_name = string
                encrypted = bool
                volume_size = number
                volume_type = string
                delete_on_termination = bool   
            }
        )
    )    
}
variable "network_settings"{
    type = object(
        {
            associate_public_ip_address = bool
            subnet_id = string
            vpc_security_group_ids = set(string)
        }
    )
}
variable "instance_type_selection"{
    type = string
}
variable "instance_profile"{
    type = string
    default = null
}
variable "tag_assignment"{
    type = map
}
variable "assign_key_pair"{
    type = string
}