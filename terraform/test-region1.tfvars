# The following variables set by the wrapper script, don't redefine them here
# - environment
# - aws_region
# - terraform_state_bucket
# - terraform_lock_table

# Global parameters
global_tags = {
  Terraform   = "true"
  Environment = "test-region1"
}

# Network configuration
availability_zones = ["us-east-1b", "us-east-1c"]
vpc_cidr           = "10.10.0.0/16"
private_subnets    = ["10.10.1.0/24", "10.10.2.0/24"]
public_subnets     = ["10.10.101.0/24", "10.10.102.0/24"]

# Allow IP ranges - e.g. vpn server
ssh_ip_access_list = ["x.x.x.x/32"]

public_dns_zone  = "test-region1.mycompany.com"
private_dns_zone = "test-region1.internal"

# Instances
ec2_ssh_public_key            = "" # some ssh bootstrap key
enable_volume_snapshot_policy = false

monitoring = {

  "region1-monitoring" = {
    ami : "ami-0fec2c2e2017f4e7b" // Debian 11
    instance_type : "t3.small"
    subnet : "public"
    availability_zone : "us-east-1c"
    volume_size_gb : 50 
  }
}
monitoring_database_enabled = false

monitoring_database = {}

bastions = {
  /*"region1-bastion-0": {
        ami : "ami-0fec2c2e2017f4e7b" // Debian 11
        instance_type: "t3.small"
        subnet: "public"
        availability_zone: "us-east-1b"
    }*/
}

# rpc node

access_nodes = {
  "test-region1-rpc-1" : {
    ami : "ami-0fec2c2e2017f4e7b" // Debian 11
    instance_type : "t3.small"
    subnet : "public"
    availability_zone : "us-east-1b"
    volume_size_gb : 50
    provisioned_iops : 100
  }
}

# collator nodes

collator_nodes = {
  "region1-collator-1" : {
    ami : "ami-0fec2c2e2017f4e7b" // Debian 11
    instance_type : "t3.small"
    subnet : "public"
    availability_zone : "us-east-1b"
    volume_size_gb : 50
    provisioned_iops : 100
  },
  "region1-collator-2" : {
    ami : "ami-0fec2c2e2017f4e7b" // Debian 11
    instance_type : "t3.small"
    subnet : "private"
    availability_zone : "us-east-1c"
    volume_size_gb : 50
    provisioned_iops : 100
  }
}

backup_nodes = {}

load_balancers = {}
