variable "environment" {
  description = "The environment name"
  type        = string
}
variable "filepath" {
  description = "Local file path to use to store the ssh-config file"
  type        = string
}

variable "bastions" {
  description = "Bastions config"
}

variable "monitoring" {
  description = "Monitoring config"
}

variable "access_nodes" {
  description = "Access nodes config"
}

variable "validator_nodes" {
  description = "Validator nodes config"
}

variable "archive_nodes" {
  description = "Archive nodes config"
}

variable "collator_nodes" {
  description = "Index nodes config"
}

variable "backup_nodes" {
  description = "Backup nodes config"
}
