# The following variables set by the wrapper script, don't redefine them here
# - environment
# - aws_region
# - terraform_state_bucket
# - terraform_lock_table

# Global parameters
global_tags = {
  Terraform   = "true"
  Environment = "region1-test"
}

# Network configuration
availability_zones = ["eu-north-1b", "eu-north-1c"]
vpc_cidr           = "10.10.0.0/16"
private_subnets    = ["10.10.1.0/24", "10.10.2.0/24"]
public_subnets     = ["10.10.101.0/24", "10.10.102.0/24"]

# Allow IP ranges - e.g. vpn server
//                   Allow all IPs
ssh_ip_access_list = ["x.x.x.x/32"]
//                          Allow all IPs
monitoring_ip_access_list = ["0.0.0.0/0"]

public_dns_zone  = "region1-test.mycompany.com"
private_dns_zone = "region1-test.internal"

// Peering
vpc_peerings           = {}
vpc_peerings_to_accept = {}

# Instances
ec2_ssh_public_key            = "" # some ssh bootstrap key
enable_volume_snapshot_policy = false

monitoring = {

  "region1-monitoring" = {
    ami : "ami-02c68996dd3d909c1" // Debian 11
    instance_type : "t3.small"
    subnet : "public"
    availability_zone : "eu-north-1c"
    volume_size_gb : 50
  }
}
monitoring_database_enabled = false

monitoring_database = {}

bastions = {
  /*"region1-bastion-0": {
        ami : "ami-02c68996dd3d909c1" // Debian 11
        instance_type: "t3.small"
        subnet: "public"
        availability_zone: "eu-north-1b"
    }*/
}

# rpc node

access_nodes = {
  "region1-test-rpc-1" : {
    ami : "ami-02c68996dd3d909c1" // Debian 11
    instance_type : "t3.small"
    subnet : "public"
    availability_zone : "eu-north-1b"
    volume_size_gb : 50
    provisioned_iops : 100
  }
}

# Blockchain nodes
validator_nodes = {}
# collator nodes

collator_nodes = {
  "region1-collator-1" : {
    ami : "ami-02c68996dd3d909c1" // Debian 11
    instance_type : "t3.small"
    subnet : "public"
    availability_zone : "eu-north-1b"
    volume_size_gb : 50
    provisioned_iops : 100
    root_disk : 400
  },
  "region1-collator-2" : {
    ami : "ami-02c68996dd3d909c1" // Debian 11
    instance_type : "t3.small"
    subnet : "private"
    availability_zone : "eu-north-1c"
    volume_size_gb : 50
    provisioned_iops : 100
    root_disk : 400
  }
}

backup_nodes = {}

load_balancers = {}

archive_nodes = {}
