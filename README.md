# Disaster Recovery with ORDS

Disaster Recovery Network and connectivity setup
=======================================================

This solution provides a Network Architecture deployment to demonstrate Disaster Recovery scenario across 2 regions [ examples are geared towards region Ashburn & Phoenix and can be used for any OCI regions].


## Quickstart Deployment

1. Clone this repository to your local host. The `DR-ORDS-RW` directory contains the Terraform configurations for a sample topology based on the architecture described earlier.
    ```
    git clone https://github.com/Chavez-Saul/DR-ORDS-RW.git
    ```

2. Install Terraform. See https://learn.hashicorp.com/terraform/getting-started/install.html.
   The current terraform script uses `terraform.0.12.29`. You can get an older version of terraform [here](https://releases.hashicorp.com/terraform/).
   After you have downloaded `terraform.0.12.29` to you machine. Move the file to the `/usr/bin`. 
3. Setup tenancy values for terraform variables by updating `env-vars` file with the required information. The file contains definitions of environment variables for your Oracle Cloud Infrastructure tenancy.
   To simplify the process. Run the `setup.sh` and input the information that is required to update the `env-vars`
    ```
    $ chmod +x setup.sh
    $ ./setup.sh
    $ source env_vars
    ```

4. Create **terraform.tfvars** from *terraform.tfvars.sample* file with the inputs for the architecture that you want to build. A running sample terraform.tfvars file is available below. The contents of sample file can be copied to create a running terraform.tfvars input file. Update db_admin_password with actual password in terraform.tfvars file.


5. Deploy the topology:

-   **Deploy Using Terraform**
    
    ```
    $ terraform init
    $ terraform plan
    $ terraform apply
    ```
    When you’re prompted to confirm the action, enter yes.

    When all components have been created, Terraform displays a completion message. For example: Apply complete! Resources: nn added, 0 changed, 0 destroyed.

6. If you want to delete the infrastructure, run:
    First navigate to OCI Console and terminate the Standby database and once the termination is successfull then run the following command
    ```
    $ terraform destroy
    ```
    When you’re prompted to confirm the action, enter yes.

## Inputs required in the terraform.tfvars file
The following inputs are required for terraform modules:

| Argument                   | Description                                                                                                                                                                                                                                                                                                                                                       |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| dr_region                         | standby region in which to operate, example: us-ashburn-1, us-phoenix-1, ap-seoul-1, ap-tokyo-1, ca-toronto-1> |
| dr_vcn_cidr_block                   | CIDR block of the VCN (Virtual Cloud Network) to be created in standby region. make sure the VCN CIDR blocks of primary and standby regions do not overlap  |
| vcn_cidr_block              | CIDR block of the VCN (Virtual Cloud Network) to be created in primary region. make sure the VCN CIDR blocks of primary and standby regions do not overlap|
| vcn_dns_label              | DNS Label of the VCN (Virtual Cloud Network) to be created.           |
| bastion_server_shape              |  This is compute shape for bastion server. For more information on available shapes, see [VM Shapes](https://docs.cloud.oracle.com/iaas/Content/Compute/References/computeshapes.htm?TocPath=Services#vmshapes)|
| db_display_name              |  The user-provided name of the Database Home|
| db_system_shape              |  The shape of the DB system. The shape determines resources allocated to the DB system.For virtual machine shapes, the number of CPU cores and memory and for bare metal and Exadata shapes, the number of CPU cores, memory, and storage. To get a list of shapes, use the [ListDbSystemShapes](https://docs.cloud.oracle.com/iaas/api/#/en/database/20160918/DbSystemShapeSummary/ListDbSystemShapes) operation.|
| db_admin_password              | A strong password for SYS, SYSTEM, PDB Admin and TDE Wallet. The password must be at least nine characters and contain at least two uppercase, two lowercase, two numbers, and two special characters. The special characters must be _, #, or -.  |


*Sample terraform.tfvars file to create Hyperion infrastructure in single availability domain architecture*

```
# DR region for standby (us-phoenix-1, ap-seoul-1, ap-tokyo-1, ca-toronto-1)
dr_region = "us-phoenix-1"

# CIDR block of Standby VCN to be created
dr_vcn_cidr_block = "10.0.0.0/16"

# CIDR block of Primary VCN to be created
vcn_cidr_block = "192.168.0.0/16"

# DNS label of VCN to be created
vcn_dns_label = "drvcn"

# Compute shape for bastion server
bastion_server_shape = "VM.Standard2.1"

# Database display name
db_display_name = "ActiveDBSystem"

# Compute shape for Database server
db_system_shape = "VM.Standard2.2"

# DB admin password for database
db_admin_password = "AAbb__111"
```
# Example of setup.sh
```
-------------------------------------------------------------------------
 Setting up environment variables to launch a compute instance for ORDS.
 Please enter required information below:
-------------------------------------------------------------------------

***** Authentication *****
Enter your tenancy's OCID [ocid1.tenancy.oc1.]:
Enter your user's OCID [ocid1.user.oc1.]:
Enter your fingerprint []:
Enter path to your SSH public key [/home/opc/.ssh/id_rsa.pub]:
Enter path to your SSH private key [/home/opc/.ssh/id_rsa]:
Enter path to your API private key [/home/opc/.oci/oci_api_key.pem]:
Enter your compartment's OCID [ocid1.compartment.oc1.]:

***** Compute Instance *****
Enter the Compute Instance's port [8888]:
***** Primary Region *****
Enter the primary region <us-phoenix-1|us-ashburn-1|eu-frankfurt-1|uk-london-1|ca-toronto-1>  [uk-london-1]:
***** Standby Region *****
Choose a region that is different from the primary region
Enter the standby region <us-phoenix-1|us-ashburn-1|eu-frankfurt-1|uk-london-1|ca-toronto-1>  [eu-frankfurt-1]:

***** File location on Object Storage *****
Enter the URL for ORDS.war file [https://objectstorage.uk-london-1.oraclecloud.com/p/XxIgzihxEAtdZvuL3kOZBYYvNIhZVomtBS0urvrYI38/n/orasenatdecanational01/b/uk-london-1-bucket-dr/o/ords.war]:
Enter the URL for APEX zip file [https://objectstorage.uk-london-1.oraclecloud.com/p/ivsobcgL9dfwsVCSSwOvMee1PBIAmDZOijz8tzt5ATM/n/orasenatdecanational01/b/uk-london-1-bucket-dr/o/apex_20.1.zip]:

***** APEX installation mode *****
Enter 0 to install APEX with Full development environment mode, or 1 to install APEX with Runtime environment mode [0]:

```

## Troubleshooting


### End