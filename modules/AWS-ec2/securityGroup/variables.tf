variable "asg"{
    type = object(
        {
            name = string 
            description = string
            vpc_id = string
        }
    )
}
variable "asg_rule"{
    type = list(object(
            {
                type        = string
                from_port   = number
                to_port     = number 
                protocol    = string
                cidr_blocks = list(string) 
            }
        )
    )
}
variable "tag_assignment"{
    type = map
}