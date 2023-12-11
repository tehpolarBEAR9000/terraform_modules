variable "instance_profile_info" {
    type = object(
        {
            name = string, 
            role = string
        }
    )
}