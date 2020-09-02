// Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.

/*
 * Create an server instance
 */

provider oci {
  alias = "destination"
}

resource oci_core_instance "private_server" {
  provider            = oci.destination
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  display_name        = var.display_name

  source_details {
    source_type = "image"
    source_id   = var.source_id
  }

  agent_config {
    is_management_disabled = true
    is_monitoring_disabled = true
  }

  shape = var.shape

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_file)
    user_data           = var.user_data
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = false

    nsg_ids = [
      var.ping_all_id
    ]
  }

  connection {
    type        = "ssh"
    host        = oci_core_instance.private_server.private_ip
    user        = "opc"
    private_key = file(var.ssh_private_key_file)

    bastion_host        = var.bastion_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.ssh_private_key_file)
  }
  # deploy application
  provisioner "remote-exec" {
    inline = [
      "set -x",
      "sudo firewall-cmd --add-service=http --permanent",
      "sudo systemctl restart firewalld",
      "sudo systemctl enable firewalld",
      "sudo yum install httpd -y",
      "sudo systemctl restart httpd",
      "sudo systemctl enable httpd",
      "echo $'<html>\n\t<body>\n\t\t<h2>Welcome to Oracle Cloud</h2>\n\t\t<embed src=\"/admin/oracle.png\" />\n\t</body>\n</html>' | sudo tee /var/www/html/index.html",
    ]
  }

}


