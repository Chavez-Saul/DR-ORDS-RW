// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

### Standby Region Outputs

output "dr_bastion" {
  value = module.dr_bastion_instance.dr_instance_ip
}

### Primary Region Outputs

output "primary_bastion" {
  value = module.bastion_instance.dr_instance_ip
}


### ords Information
output "ords_public_ip" {
  value = module.ords.InstancePublicIP
}

### Database Information
output "DB_hostname" {
  value = module.database.db_hostname
}

output "db_ip" {
  value = module.database.db_node_private_ip
}
output "db_domain" {
  value = module.database.db_domain
}

output "URL_for_Apex" {
  value = "https://${module.ords.InstancePublicIP}:${var.com_port}/ords/${module.database.pdb_name}"
}

