variable "set_bucket_details" {
    type = object(
        {
            bucket_name = string 
        }
    )
}
variable "tag_assignment"{
    type = map
}
variable "set_lifecycles_policies" {
    description = ""
    type = object({
        status = string
        prefix = string
        id = string
        Deep_Glacier = object({
            days    =  number
            storage_class = string
        })
        Flex_Glacier = object({
            days    = number
            storage_class = string 
        })
    
    })
    default = { 
        id = "Glacier_Archival_Transition"
        status = "Enabled"
        prefix = "/"
        Deep_Glacier = {days = 180, storage_class = "DEEP_ARCHIVE"}
        Flex_Glacier = {days = 30, storage_class = "GLACIER" }
    }
}