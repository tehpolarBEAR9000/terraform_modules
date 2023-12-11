locals {
	roles = var.role_statement
}


data "aws_iam_policy_document" "example_two" {
	dynamic "statement" {
		for_each = {
			for index, role_statement in local.roles:
				index => role_statement
	}
	content {
		effect = statement.value.Effect
		actions = [statement.value.Action]
	
		principals {
			type = statement.value.Principal.kind
			identifiers = [statement.value.Principal.Service[0]]
		}
	}
	
}


}


resource "aws_iam_role" "return_role_name"{
	name = var.role_name 
	assume_role_policy = data.aws_iam_policy_document.example_two.json
}




