locals {
  statements = var.policy_statement 
}    

data "aws_iam_policy_document" "example" {
    dynamic "statement" {    
        for_each = {
            for index, policy_statement in local.statements:
                index => policy_statement
        }
        content {
            actions = statement.value.Action
            resources = statement.value.Resource 
            effect = statement.value.Effect
        }
    }    
}


resource "aws_iam_policy" "return_policy_name"{
    name = var.policy_name
    policy = data.aws_iam_policy_document.example.json 
}

