####################
#       VPC        #
####################
module "vpc" {
  source = "../modules/vpc"

  name               = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  tags               = var.global_tags
}
####################
#    Peering       #
####################
module "peering" {
  source = "../modules/peering"

  environment            = var.environment
  vpc_id                 = module.vpc.vpc_id
  vpc_peerings           = var.vpc_peerings
  vpc_peerings_to_accept = var.vpc_peerings_to_accept
  vpc_route_table_ids    = module.vpc.private_route_table_ids
  tags                   = var.global_tags
}

####################
#    DNS ZONE      #
####################
module "dns_zones" {
  source = "../modules/dns-zones"

  public_dns_zone  = var.public_dns_zone
  private_dns_zone = var.private_dns_zone

  environment = var.environment
  vpc_id      = module.vpc.vpc_id

  tags = var.global_tags
}

####################
#     Key Pair     #
####################
module "key_pair" {
  source = "../modules/key-pair"

  name           = "${var.environment}-key-pair"
  ssh_public_key = var.ec2_ssh_public_key

  tags = var.global_tags

  depends_on = [module.vpc]
}

####################
#     Bastions     #
####################
module "bastions" {
  source = "../modules/bastions"

  bastions = var.bastions

  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  vpc_id              = module.vpc.vpc_id
  ssh_ip_access_list  = var.ssh_ip_access_list
  key_pair            = module.key_pair.key_pair_id
  public_dns_zone_id  = module.dns_zones.public_zone_id
  private_dns_zone_id = module.dns_zones.private_zone_id

  tags = var.global_tags
}

####################
#    Monitoring    #
###################
module "monitoring" {
  source = "../modules/monitoring"

  monitoring = var.monitoring

  name                      = "${var.environment}-monitoring"
  environment               = var.environment
  aws_region                = var.aws_region
  vpc_id                    = module.vpc.vpc_id
  vpc_cidr_block            = var.vpc_cidr
  bastion_ips               = module.bastions.bastion_private_ips
  monitoring_ip_access_list = var.monitoring_ip_access_list
  key_pair                  = module.key_pair.key_pair_id
  public_dns_zone           = var.public_dns_zone
  public_dns_zone_id        = module.dns_zones.public_zone_id
  private_dns_zone_id       = module.dns_zones.private_zone_id
  ssh_ip_access_list        = var.ssh_ip_access_list

  tags = var.global_tags
}

module "monitoring-database" {
  source = "../modules/monitoring-database"

  enabled = var.monitoring_database_enabled

  aws_region              = var.aws_region
  environment             = var.environment
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  blockscout_instance_ips = []

  database_instance_class = var.monitoring_database.instance_class
  allocated_storage       = var.monitoring_database.allocated_storage
  max_allocated_storage   = var.monitoring_database.max_allocated_storage

  tags = var.global_tags
}

######################
# Common Node Config #
######################
module "common_nodes_security_group" {
  source = "../modules/blockchain/common-nodes-security-group"

  name                   = "${var.environment}-common-nodes-sg"
  vpc_id                 = module.vpc.vpc_id
  vpc_cidr_block         = module.vpc.vpc_cidr_block
  bastion_ips            = module.bastions.bastion_private_ips
  monitoring_ips         = module.monitoring.monitoring_private_ips
  vpc_peerings           = var.vpc_peerings
  vpc_peerings_to_accept = var.vpc_peerings_to_accept
  ssh_ip_access_list     = var.ssh_ip_access_list

  tags = var.global_tags
}

####################
# Validator Nodes  #
####################
module "validator_nodes" {
  source = "../modules/blockchain/validator-nodes"

  validator_nodes = var.validator_nodes

  environment               = var.environment
  vpc_cidr                  = module.vpc.vpc_cidr_block
  vpc_id                    = module.vpc.vpc_id
  key_pair                  = module.key_pair.key_pair_id
  public_dns_zone_id        = module.dns_zones.public_zone_id
  private_dns_zone_id       = module.dns_zones.private_zone_id
  common_security_group_ids = [module.common_nodes_security_group.security_group_id]

  tags = var.global_tags
}

####################
#   Access Nodes   #
####################
module "access_nodes" {
  source = "../modules/blockchain/access-nodes"

  access_nodes = var.access_nodes

  environment               = var.environment
  vpc_cidr                  = module.vpc.vpc_cidr_block
  vpc_id                    = module.vpc.vpc_id
  key_pair                  = module.key_pair.key_pair_id
  public_dns_zone_id        = module.dns_zones.public_zone_id
  private_dns_zone_id       = module.dns_zones.private_zone_id
  common_security_group_ids = [module.common_nodes_security_group.security_group_id]

  tags = var.global_tags
}
####################
#   Archive Nodes  #
####################
module "archive_nodes" {
  source = "../modules/blockchain/archive-nodes"

  archive_nodes = var.archive_nodes

  environment               = var.environment
  vpc_cidr                  = module.vpc.vpc_cidr_block
  vpc_id                    = module.vpc.vpc_id
  key_pair                  = module.key_pair.key_pair_id
  public_dns_zone_id        = module.dns_zones.public_zone_id
  private_dns_zone_id       = module.dns_zones.private_zone_id
  common_security_group_ids = [module.common_nodes_security_group.security_group_id]

  tags = var.global_tags
}

module "collator_nodes" {
  source = "../modules/blockchain/collator-nodes"

  collator_nodes = var.collator_nodes

  environment               = var.environment
  vpc_cidr                  = module.vpc.vpc_cidr_block
  vpc_id                    = module.vpc.vpc_id
  key_pair                  = module.key_pair.key_pair_id
  public_dns_zone_id        = module.dns_zones.public_zone_id
  private_dns_zone_id       = module.dns_zones.private_zone_id
  common_security_group_ids = [module.common_nodes_security_group.security_group_id]

  tags = var.global_tags
}

####################
#   Backup Nodes  #
####################
module "backup_nodes" {
  source = "../modules/blockchain/backup-nodes"

  backup_nodes = var.backup_nodes

  environment               = var.environment
  vpc_cidr                  = module.vpc.vpc_cidr_block
  vpc_id                    = module.vpc.vpc_id
  key_pair                  = module.key_pair.key_pair_id
  public_dns_zone_id        = module.dns_zones.public_zone_id
  private_dns_zone_id       = module.dns_zones.private_zone_id
  common_security_group_ids = [module.common_nodes_security_group.security_group_id]

  tags = var.global_tags
}

####################
#  Load balancers  #
####################
module "custom_load_balancer" {
  source = "../modules/custom-load-balancer"

  load_balancers = var.load_balancers

  name               = "${var.environment}-rpc-lb"
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  public_dns_zone    = var.public_dns_zone
  public_dns_zone_id = module.dns_zones.public_zone_id

  tags = var.global_tags
}
####################
#  SSH config      #
####################
// Save the ssh config to the local repository $ENV.ssh_config file
// for it to be ready to use by the Ansible playbook
module "ssh_config" {
  source = "../modules/ssh-config"

  filepath = "${path.module}/../../ansible/${var.environment}.ssh_config"

  environment     = var.environment
  bastions        = module.bastions.instances
  monitoring      = module.monitoring.instances
  access_nodes    = module.access_nodes.instances
  validator_nodes = module.validator_nodes.instances
  archive_nodes   = module.archive_nodes.instances
  collator_nodes  = module.collator_nodes.instances
  backup_nodes    = module.backup_nodes.instances
}

#########################
#  Auto Disk Snapshot   #
#########################
module "volume_snapshot_policy" {
  count = var.enable_volume_snapshot_policy ? 1 : 0

  source = "../modules/volume-snapshot-policy"

  environment = var.environment
  tags        = var.global_tags
}
