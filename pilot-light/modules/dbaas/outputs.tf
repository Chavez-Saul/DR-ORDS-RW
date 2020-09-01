output db_hostname {
  value = oci_database_db_system.db_system.hostname
}

output ip {
  value = data.oci_core_vnic.test_node.private_ip_address
}
