variable availability_domain {
  type        = string
  description = "the availability downmain to provision the management instance in"
}

variable "tenancy_ocid" {
  type        = string
  description = "tenancy ocid"
}

variable compartment_id {
  type        = string
  description = "ocid of the compartment to provision the resources in"
}

variable display_name {
  type        = string
  description = "name of instance"
}

variable hostname_label {
  type        = string
  description = "hostname label"
}

variable subnet_id {
  type        = string
  description = "ocid of the subnet to provision the management instance in"
}

variable shape {
  type        = string
  description = "oci shape for the instance"
  default     = "VM.Standard2.2"
}

variable "BootStrapFile" {
  default = "./userdata/bootstrap.sh"
}

variable source_id {
  type        = string
  description = "ocid of the image to provistion the management instance with"
}

variable "ssh_public_key" {
  type        = string
  description = "path to public ssh key for all instances deployed in the environment"
}
