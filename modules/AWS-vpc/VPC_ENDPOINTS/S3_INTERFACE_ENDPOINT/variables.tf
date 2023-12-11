variable "vpc_id" {
    type = string
}
variable "service_name"{
    type = string
}
variable "apply_security_group"{
    type = list(string)
}
variable "subnet_data" {
    type = list(string)
}
variable "privateDnsInboundResolver"{
	type = string
	default = true
}
variable "inbound_resolver_endpoint"{
    type = string
    default = false
}