locals {
  acls = var.asg_rule 
}    

resource "aws_security_group" "awssecuritygroup"{
    name = var.asg.name
    description = var.asg.description
    vpc_id = var.asg.vpc_id

    tags = var.tag_assignment
    
}

resource "aws_security_group_rule" "security_group_rule"{
    security_group_id = aws_security_group.awssecuritygroup.id

    for_each   = {
        for index, acl in local.acls:
        index => acl
    }

    type = each.value.type
    from_port = each.value.from_port 
    to_port = each.value.to_port 
    protocol = each.value.protocol 
    cidr_blocks = each.value.cidr_blocks
}

