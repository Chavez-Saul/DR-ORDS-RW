#Copyright © 2020, Oracle and/or its affiliates.
#The Universal Permissive License (UPL), Version 1.0

# DR region for standby (us-phoenix-1, ap-seoul-1, ap-tokyo-1, ca-toronto-1)
dr_region = "eu-frankfurt-1"

# CIDR block of Standby VCN to be created
dr_vcn_cidr_block = "192.168.0.0/16"

# CIDR block of Primary VCN to be created
vcn_cidr_block = "10.0.0.0/16"

# DNS label of VCN to be created
vcn_dns_label = "drx1"

# Compute shape for bastion server
bastion_server_shape = "VM.Standard2.1"

# Compute shape for application servers
app_server_shape = "VM.Standard2.1"

# Database display name
db_display_name = "ActiveDBSystem"

# Compute shape for Database server
db_system_shape = "VM.Standard2.2"

# DB admin password for database
db_admin_password = "PPassw0rd##123"

# shape for Load Balancer
lb_shape = "100Mbps"



