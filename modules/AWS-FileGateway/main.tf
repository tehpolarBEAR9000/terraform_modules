resource "aws_storagegateway_gateway" "gateway_standup"{
    gateway_vpc_endpoint = var.storage_gateway.gateway_vpc_endpoint 
    gateway_ip_address = var.storage_gateway.gateway_ip_address 
    gateway_name = var.storage_gateway.gateway_name 
    gateway_type = var.storage_gateway.gateway_type 
    gateway_timezone = var.storage_gateway.gateway_timezone
    
    cloudwatch_log_group_arn = var.cwl_arn 

    smb_active_directory_settings {
      domain_name = var.set_activeDirectory.domain_name
      username = var.set_activeDirectory.username
      password = var.set_activeDirectory.password 
      organizational_unit = var.set_activeDirectory.organizational_unit
    }

    tags = var.tag_assignment
}
