resource "aws_vpc_endpoint" "S3_PrivateLink_Endpoint"{

    vpc_id = var.vpc_id
    vpc_endpoint_type = "Interface"
    service_name = var.service_name 
    subnet_ids = var.subnet_data

    security_group_ids = var.apply_security_group  
    
    private_dns_enabled = var.privateDnsInboundResolver

    dns_options{
        private_dns_only_for_inbound_resolver_endpoint = var.inbound_resolver_endpoint
    }
    
}

