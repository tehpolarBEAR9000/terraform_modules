variable "set_activeDirectory"{
    type = object(
        {
            domain_name = string
            username = string
            password = string
            organizational_unit = string   
        }
    )
}
variable "storage_gateway"{
    type = object(
        {
            gateway_vpc_endpoint = string
            gateway_ip_address = string
            gateway_name = string
            gateway_type = string
            gateway_timezone = string
        }
    )
}
variable "tag_assignment"{
    type = map
}
variable "cwl_arn"{
    type = string
}