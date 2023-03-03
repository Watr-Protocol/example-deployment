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
ssh_ip_access_list = ["212.227.197.206/32"]
//                          Allow all IPs
monitoring_ip_access_list = ["0.0.0.0/0"]

public_dns_zone  = "deploy.paritytech.io"
private_dns_zone = "region1-test.internal"

// Peering
vpc_peerings = {}
vpc_peerings_to_accept = {}

# Instances
# ec2_ssh_public_key            = "" # some ssh bootstrap key
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
  },
  "region1-collator-2" : {
    ami : "ami-02c68996dd3d909c1" // Debian 11
    instance_type : "t3.small"
    subnet : "private"
    availability_zone : "eu-north-1c"
    volume_size_gb : 50
    provisioned_iops : 100
  }
}

backup_nodes = {}

load_balancers = {}

archive_nodes = {}

ec2_ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRBe+pgD0IkPkHXBYTw6fLzybcLBhoKF24cL8e/CgtFjZzPTo3zQIKbz+3NcjF9S72jIFwdNtPLYt//xbXTwUAl+IJqKHBeQQHpWHsHm0yXecocm0Sjd+PKphYW0Tz+85ebGlY3kjahpmbBhv4shN5CbEBqxgtOLb0U+v8Y0insDH6yyjl0h+exzrTMuOqCmwNXE0Eqr3HJRgtrPv47nnQ8gFfkA3WEbHGene4vylEblIA7w8O1oDaw6GoojdsZCztluuHV+TN/07NAlhss52qfBzOiChh+xWnphggysrFLsZVBHQNun6E1L67PbCRPhDuGcPNw1xp/e1g7WNHKWg6/Oq+ilVw++RpE+QDGt42x2esSduMHBfXAhe5pQb9CmwgG86z50U+DZ4d/JYsjGTixDjleGZjihFiW+zgP0UhtDXM0MuxmGKi5csV6m2TQ7xFZdxXNT2u7y4SX+TOAIAduoUNNPFLom2ZR+N3tmS908siVhmRR/TmcvPub8fhHQbXX8YAu1hSP+cSbjcm1qEey9A9+KQxNc5A+0dd+J3E5d4R9ya84r7hpg1elTLHDnsXnAaCxrn498I0tj76RnnHFSr2IQs52KZOe92Y03jLJtek4GlKn0mbefEmAyIE6btjzOniegVBe5L3NJZ/8f0pmSh/0U5470JkUv9d1h+UcQ== cardno:11 513 686"
