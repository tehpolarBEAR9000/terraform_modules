terraform {
  backend "s3" {
    bucket         	 = "{bucket}"
    key              = "{key}.tfstate"
    encrypt        	 = true
    dynamodb_table   = "state_file_lock_tracking"
    region           = "us-east-2"
  }
}
terraform{
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 4.16"
        configuration_aliases = [aws.dev]
      }
    }
    required_version = ">= 1.2.0"
}
provider "aws" {
  alias = "dev"
  region = "us-east-2"
  shared_credentials_files = ["C:\\path\\to\\aws\\credentials"]
  profile = "default"
}
provider "aws" {
  region = "us-east-2"
  shared_credentials_files = ["C:\\path\\to\\aws\\credentials"]
  profile = "{aws_profile_name}"
}
module "createCWL" {
    source = "../../modules/AWS-CloudWatch"
    group_name = "cwl_log_group_name"
    retention =  "0"
    tag_assignment =  {
        "env" : "prod",
        "app" : "{app_name}"
      }
}
module "create_S3_Bucket_for_smb"{
    source = "../../modules/AWS-s3"
    set_bucket_details = {
      bucket_name = "{s3_bucket_name}"
    }
    tag_assignment = {
      "env":"prod",
      "app":"{app_name}"
    }
}
module "createStorageGateway_VPC_INTERFACE_ENDPOINT" {
    source = "../../modules/AWS-vpc/VPC_ENDPOINTS/SGW_INTERFACE_ENDPOINT"
    vpc_id = "{vpc_id}"
    service_name = "com.amazonaws.us-east-2.storagegateway"
    subnet_data = [
      "{subnet_id}"
    ]
    apply_security_group = [
      "${module.createStorageGateway_VPC_INTERFACE_ENDPOINT_SECURITY_GROUP.security_group_return_id}"
    ]
}
module "create_S3_VPC_INTERFACE_ENDPOINT"{
    source = "../../modules/AWS-vpc/VPC_ENDPOINTS/SGW_INTERFACE_ENDPOINT"
    vpc_id = "{vpc_id}"
    service_name = "com.amazonaws.us-east-2.s3"
    subnet_data = [
      "{subnet_id}"
    ]
    apply_security_group = [
      "${module.create_S3_VPC_INTERFACE_ENDPOINT_SECURITY_GROUP.security_group_return_id}"
    ]
    privateDnsInboundResolver = false 
}
module "createStorageGateway_VPC_INTERFACE_ENDPOINT_SECURITY_GROUP" {
    source = "../../modules/AWS-ec2/securityGroup"
    asg = {
      name = "storage-gateway_interface_endpoint_sg"
      description = "allows private routing to StorageGateway"
      vpc_id = "{vpc_id}"
    }
    tag_assignment = {
      "env" : "prod",
      "app" : "{app_name}"
    }
    asg_rule =[
        {
            "type":"ingress",
            "from_port":"443",
            "to_port":"443",
            "protocol":"tcp",
            "cidr_blocks":["{cidr_ip}"]
        },
        {
            "type":"ingress",
            "from_port":"1026",
            "to_port":"1028",
            "protocol":"tcp",
            "cidr_blocks":["{cidr_ip}"]
        },
        {
            "type":"ingress",
            "from_port":"1031",
            "to_port":"1031",
            "protocol":"tcp",
            "cidr_blocks":["{cidr_ip}"]
        },
        {
          "type":"egress",
          "from_port":"0",
          "to_port":"65535",
          "protocol":"tcp",
          "cidr_blocks":["{cidr_ip}"]
        }
    ]
}
module "create_S3_VPC_INTERFACE_ENDPOINT_SECURITY_GROUP"{
    source = "../../modules/AWS-ec2/securityGroup"
    asg = {
      name = "s3_interface_endpoint_sg"
      description = "allows private routing to s3 from vpc"
      vpc_id = "{vpc_id}"
    }
    tag_assignment = {
      "env" : "prod",
      "app" : "{app_name}"
    }
    asg_rule =[
        {
            "type":"ingress",
            "from_port":"443",
            "to_port":"443",
            "protocol":"tcp",
            "cidr_blocks":["{cidr_ip}"]
        },
        {
          "type":"egress",
          "from_port":"0",
          "to_port":"65535",
          "protocol":"tcp",
          "cidr_blocks":["{cidr_ip}"]
        }
    ]
}
module "create_FILE_GATEWAY_EC2_Security_GROUPS"{
    source = "../../modules/AWS-ec2/securityGroup"
    asg = {
      name = "allow_access_FileGateway"
      description = "allows user and management level network access"
      vpc_id = "{vpc_id}"
    }
    tag_assignment = {
      "env" : "prod",
      "app" : "{app_name}"
    }
    asg_rule = [
      {
        "type":"ingress",
        "from_port":"22",
        "to_port":"22",
        "protocol":"tcp",
        "cidr_blocks":["{cidr_ip}"]
      },
      {
        "type":"ingress",
        "from_port":"80",
        "to_port":"80",
        "protocol":"tcp",
        "cidr_blocks":["{cidr_ip}"]
      },
      {
        "type":"ingress",
        "from_port":"137",
        "to_port":"139",
        "protocol":"tcp",
        "cidr_blocks":["{cidr_ip}"]
      },
      {
        "type":"ingress",
        "from_port":"389",
        "to_port":"389",
        "protocol":"tcp",
        "cidr_blocks":["{cidr_ip}"]
      },
      {
        "type":"ingress",
        "from_port":"88",
        "to_port":"88",
        "protocol":"tcp",
        "cidr_blocks":["{cidr_ip}"]
      },
      {
        "type":"ingress",
        "from_port":"88",
        "to_port":"88",
        "protocol":"tcp",
        "cidr_blocks":["{cidr_ip}"]
      },
      {
        "type":"ingress",
        "from_port":"135",
        "to_port":"135",
        "protocol":"tcp",
        "cidr_blocks":["{cidr_ip}"]
      },
      {
        "type":"egress",
        "from_port":"0",
        "to_port":"65535",
        "protocol":"tcp",
        "cidr_blocks":["{cidr_ip}"]
      },
      {
        "type":"ingress",
        "from_port":"445",
        "to_port":"445",
        "protocol":"tcp",
        "cidr_blocks":["{cidr_ip}"]
      },
            {
        "type":"ingress",
        "from_port":"53",
        "to_port":"53",
        "protocol":"udp",
        "cidr_blocks":["{cidr_ip}"]
      },
      {
        "type":"egress",
        "from_port":"0",
        "to_port":"65535",
        "protocol":"udp",
        "cidr_blocks":["{cidr_ip}"]
      },
      {
        "type":"ingress",
        "from_port":"22",
        "to_port":"22",
        "protocol":"tcp",
        "cidr_blocks":["{cidr_ip}"]
      },
      {
        "type":"ingress",
        "from_port":"80",
        "to_port":"80",
        "protocol":"tcp",
        "cidr_blocks":["{cidr_ip}"]
      }
    ]
}
module "create_IAM_Role_for_EC2"{
  source = "../../modules/AWS-IAM"
  role_name = "s3_access_allow_ec2_role"
  policy_name = "s3_access_allow_ec2_policy"
  resource_arn = module.create_S3_Bucket_for_smb.name.arn

  role_statement = [
    {
      Effect = "Allow"
      Principal = {
          Service = ["s3.amazonaws.com"]
          kind = "Service"
      }
      Action = "sts:AssumeRole"
    },
    {
        Effect = "Allow"
        Principal = {
            Service = ["storagegateway.amazonaws.com"]
            kind = "Service"
        }
        Action = "sts:AssumeRole"
    }
  ]
    policy_statement = [
        {
        Action = [
            "s3:GetAccelerateConfiguration",
            "s3:GetBucketLocation",
            "s3:GetBucketVersioning",
            "s3:ListBucket",
            "s3:ListBucketVersions",
            "s3:ListBucketMultipartUploads"
        ]
        Resource = ["${module.create_S3_Bucket_for_smb.name.arn}"]
        Effect = "Allow"
        },
        {
        Action = [
            "s3:AbortMultipartUpload",
            "s3:DeleteObject",
            "s3:DeleteObjectVersion",
            "s3:GetObject",
            "s3:GetObjectAcl",
            "s3:GetObjectVersion",
            "s3:ListMultipartUploadParts",
            "s3:PutObject",
            "s3:PutObjectAcl"
        ],
        Resource = ["${module.create_S3_Bucket_for_smb.name.arn}/*"]
        Effect = "Allow"
        }
    ]
}
module "create_EC2_instance_profile"{
  source = "../../modules/AWS-IAM/instance_profile"
  instance_profile_info = {
    name = "storage-gateway-allow-s3-role"
    role = module.create_IAM_Role_for_EC2.role.name
  }
}
module "create_IAM_Role_for_SGW-FileShare"{
  source = "../../modules/AWS-IAM"
  role_name = "AllowStorageGatewayAssumeBucketAccessRole"
  policy_name = "AllowStorageGatewayAssumeBucketAccessPolicy"
  resource_arn = module.create_S3_Bucket_for_smb.name.arn

  role_statement = [
    {
      Effect = "Allow"
      Principal = {
          Service = ["storagegateway.amazonaws.com"]
          kind = "Service"
      }
      Action = "sts:AssumeRole"
    }
  ]
    policy_statement = [
        {
        Action = [
            "s3:GetAccelerateConfiguration",
            "s3:GetBucketLocation",
            "s3:GetBucketVersioning",
            "s3:ListBucket",
            "s3:ListBucketVersions",
            "s3:ListBucketMultipartUploads"
        ]
        Resource = ["${module.create_S3_Bucket_for_smb.name.arn}"]
        Effect = "Allow"
        },
        {
        Action = [
            "s3:AbortMultipartUpload",
            "s3:DeleteObject",
            "s3:DeleteObjectVersion",
            "s3:GetObject",
            "s3:GetObjectAcl",
            "s3:GetObjectVersion",
            "s3:ListMultipartUploadParts",
            "s3:PutObject",
            "s3:PutObjectAcl"
        ],
        Resource = ["${module.create_S3_Bucket_for_smb.name.arn}/*"]
        Effect = "Allow"
        }
    ]
}
module "create_FILE_GATEWAY_EC2"{
        source = "../../modules/AWS-ec2/compute"
        assign_key_pair = "ami_copy"
        ami_filter = {
          most_recent = "true"
          filter_name = "name"
          filter_values = ["aws-storage-gateway-1679579517"]
        }
        root_block_storage = {
          encrypted = "true"
          volume_size = "80"
          volume_type = "gp2"
          delete_on_termination = "false"
        }
        ebs_block_storage = [
          {
            device_name = "/dev/sdf"
            encrypted = "true" 
            volume_size = "150"
            volume_type = "gp2"
            delete_on_termination = "false"
          }
        ]
        tag_assignment = {
          "env" : "prod",
          "app" : "{app_name}"
        }
        network_settings = {
          associate_public_ip_address = "false"
          subnet_id = "{subnet_id}"
          vpc_security_group_ids = [
            "${module.create_FILE_GATEWAY_EC2_Security_GROUPS.security_group_return_id}"
          ]
        }
        instance_type_selection = "m5.xlarge"
        instance_profile = module.create_EC2_instance_profile.instance_profile_name.name
}
module "create_Storage_Gateway" {
  source = "../../modules/AWS-FileGateway"
    set_activeDirectory = {
      domain_name="{domain_name}"
      username="{domain_user_name}"
      password="{domain_password}"
      organizational_unit="{Active_Directory_OU}"
    }
    storage_gateway = {
      gateway_vpc_endpoint= module.createStorageGateway_VPC_INTERFACE_ENDPOINT.vpc_endpoint.dns_entry[0].dns_name
      gateway_ip_address= module.create_FILE_GATEWAY_EC2.aws_instance_info[0].private_ip
      gateway_name="{storage_gateway_name}"
      gateway_type="FILE_S3"
      gateway_timezone="GMT-4:00"
    }
    tag_assignment = {
      "env": "prod",
      "app" :"{app_name}"
    }
    cwl_arn= module.createCWL.cloudwatch_log_group_resource
}