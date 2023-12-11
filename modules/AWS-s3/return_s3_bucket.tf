resource "aws_s3_bucket" "return_s3_bucket"{
    bucket = var.set_bucket_details.bucket_name
    lifecycle {
      prevent_destroy = true
    }
    tags = var.tag_assignment
}
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_true"{
    bucket = aws_s3_bucket.return_s3_bucket.id

    rule {
        apply_server_side_encryption_by_default {
          sse_algorithm = "AES256"
        }
    }   
}
resource "aws_s3_bucket_public_access_block" "public_access_false"{
    bucket = aws_s3_bucket.return_s3_bucket.id

    block_public_acls = true 
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true  
}   
resource "aws_s3_bucket_lifecycle_configuration" "retention_period_definition"{
    bucket = aws_s3_bucket.return_s3_bucket.id

    rule {
        id = var.set_lifecycles_policies.id 

        status = var.set_lifecycles_policies.status

        filter{
        	prefix = var.set_lifecycles_policies.prefix 
        }
        transition{
            days = var.set_lifecycles_policies.Flex_Glacier.days
            storage_class = var.set_lifecycles_policies.Flex_Glacier.storage_class
        }
        transition{
            days = var.set_lifecycles_policies.Deep_Glacier.days
            storage_class = var.set_lifecycles_policies.Deep_Glacier.storage_class
        } 
    }
}