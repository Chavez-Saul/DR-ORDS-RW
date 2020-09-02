// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

### Standby Region Outputs

output "dr_bastion" {
  value = module.dr_bastion_instance.dr_instance_ip
}

output "dr_load_balancer" {
  value = module.dr_public_lb.dr_lb_ip
}

### Primary Region Outputs

output "primary_bastion" {
  value = module.bastion_instance.dr_instance_ip
}

output "primary_app_server_1" {
  value = module.app_server_1.instance_ip
}

output "primary_app_server_2" {
  value = module.app_server_2.instance_ip
}

output "primary_load_balancer" {
  value = module.public_lb.dr_lb_ip
}

### ords Information
output "InstancePrivateIP" {
  value = module.ords.InstancePrivateIP
}

output "InstancePublicIP" {
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
  value = "http://${module.ords.InstancePublicIP}:${var.port}/ords/${module.database.pdb_name}.${module.database.db_domain}"
}