variable "role_name"{
    type = string
}
variable "policy_name"{
    type = string
}
variable "resource_arn"{
    type = string
}
variable "policy_statement"{
    type = list(
        object(
            {
                Action = list(string)
                Resource = list(string)
                Effect = string
            }
        )
    )
}
variable "role_statement" {
    type = list(
        object(
            {
                Effect = string 
                Action = string
                Principal = object(
                    {
                        kind = string
                        Service = list(string)
                    }
                )
                
            }
        )
    )
}