locals {
  storageConfig = var.ebs_block_storage
}   

data "aws_ami" "store_image"{
    most_recent = var.ami_filter.most_recent

    filter { 
        name = var.ami_filter.filter_name
        values = var.ami_filter.filter_values
    }
}

resource "aws_instance" "ec2_instance"{
    ami = data.aws_ami.store_image.id
    instance_type = var.instance_type_selection
    key_name = var.assign_key_pair
    associate_public_ip_address = var.network_settings.associate_public_ip_address #false 

    root_block_device {
      encrypted = var.root_block_storage.encrypted 
      volume_size = var.root_block_storage.volume_size
      volume_type = var.root_block_storage.volume_type
      delete_on_termination = var.root_block_storage.delete_on_termination 
      tags = var.tag_assignment
    }

    for_each   = {
        for index, config in local.storageConfig:
        index => config
    }

    ebs_block_device {
        device_name = each.value.device_name
        encrypted = each.value.encrypted 
        volume_size = each.value.volume_size 
        volume_type = each.value.volume_type 
        delete_on_termination = each.value.delete_on_termination  
        tags = var.tag_assignment
    }

    subnet_id = var.network_settings.subnet_id
    vpc_security_group_ids = var.network_settings.vpc_security_group_ids

    iam_instance_profile = var.instance_profile
}