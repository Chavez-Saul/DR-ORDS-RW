resource "oci_dns_record" "ORDS-Record-a" {
##TODO need to add count index
  count = 1 - var.Secure_FQDN_access # if Secure_FQDN_access=0 then Record resource is configured

  zone_name_or_id = oci_dns_zone.ORDS-Zone[count.index].name
  domain          = "${var.InstanceName}.${oci_dns_zone.ORDS-Zone[count.index].name}"
  rtype           = "A"
  rdata           = oci_core_instance.ORDS-Comp-Instance.public_ip
  ttl             = 60
}

