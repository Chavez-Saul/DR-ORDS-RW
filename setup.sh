#!/bin/bash

echo "-------------------------------------------------------------------------"
echo " Setting up environment variables to launch a compute instance for ORDS."
echo " Please enter required information below: "
echo "-------------------------------------------------------------------------"
echo ""

cd `dirname $0`
stamp=`date +%Y%m%d_%H%M%S`

### Reading current setting variables
# checking env-vars file exists
if [ ! -e env-vars ]; then
  no_env-vars=true
  echo "INFO: env-vars file is not found in `pwd`."
  echo "      It will be newly created."
else
  grep = env-vars | grep -v '^#.*' | grep -v "cat " > .env-vars_1_${stamp}
  source .env-vars_1_${stamp}
fi

for i in PathToYourSshPublicKey PathToYourSshPrivateKey PathToYourApiPrivateKey
do
  if ! eval echo '$'${i} | grep / >/dev/null; then
    export ${i}=
  fi
done

echo "***** Authentication *****"
read -p "Enter your tenancy's OCID [${TF_VAR_tenancy_ocid}]: " TENANCYID
read -p "Enter your user's OCID [${TF_VAR_user_ocid}]: " USERID
read -p "Enter your fingerprint [${TF_VAR_fingerprint}]: " FINGERPRINT
read -p "Enter path to your SSH public key [${PathToYourSshPublicKey}]: " SSHPUBKEYPATH
read -p "Enter path to your SSH private key [${PathToYourSshPrivateKey}]: " SSHPRIVKEYPATH
read -p "Enter path to your API private key [${PathToYourApiPrivateKey}]: " APIPRIVKEYPATH
read -p "Enter your compartment's OCID [${TF_VAR_compartment_ocid}]: " CID 
echo ""

echo "***** Compute Instance *****"
read -p "Enter the Compute Instance's port [${TF_VAR_com_port}]: " COMPORT

echo "***** Primary Region *****"
read -p "Enter the primary region <us-phoenix-1|us-ashburn-1|eu-frankfurt-1|uk-london-1|ca-toronto-1>  [${TF_VAR_region}]: " PRIMARY

echo "***** Standby Region *****"
echo "Choose a region that is different from the primary region"
read -p "Enter the standby region <us-phoenix-1|us-ashburn-1|eu-frankfurt-1|uk-london-1|ca-toronto-1>  [${TF_VAR_dr_region}]: " STANDBY

echo ""

echo "***** File location on Object Storage *****"
read -p "Enter the URL for ORDS.war file [${TF_VAR_URL_ORDS_file}]: " URLORDS
read -p "Enter the URL for APEX zip file [${TF_VAR_URL_APEX_file}]: " URLAPEX

echo ""
echo "***** APEX installation mode *****"
read -p "Enter 0 to install APEX with Full development environment mode, or 1 to install APEX with Runtime environment mode [${TF_VAR_APEX_install_mode}]: " APEXINSTMODE

echo ""
echo "INFO: Updating values..."

### Update env-vars file with given parameters
if [ ! "$no_env-vars" = "true" ]; then
  cp env-vars .env-vars_2_${stamp}
  while read line
  do
    i=`echo "$line"|awk '{print $1}'`
    j=`echo "$line"|awk '{print $2}'`
    echo $i | grep -v '^#.*' > /dev/null
    if [ $? -eq 0 ];then
      if [ "$i" = "export" ]; then
        case "$j" in
          TF_VAR_tenancy_ocid* )        echo "export TF_VAR_tenancy_ocid=${TENANCYID:=${TF_VAR_tenancy_ocid}}"               >> .new_env-vars_${stamp};;
          TF_VAR_user_ocid* )           echo "export TF_VAR_user_ocid=${USERID:=${TF_VAR_user_ocid}}"                        >> .new_env-vars_${stamp};;
          TF_VAR_fingerprint* )         echo "export TF_VAR_fingerprint=${FINGERPRINT:=${TF_VAR_fingerprint}}"               >> .new_env-vars_${stamp};;
          TF_VAR_compartment_ocid* )    echo "export TF_VAR_compartment_ocid=${CID:=${TF_VAR_compartment_ocid}}"             >> .new_env-vars_${stamp};;
          TF_VAR_target_db_ip* )        echo "export TF_VAR_target_db_ip=${DBHOSTIP:=${TF_VAR_target_db_ip}}"                >> .new_env-vars_${stamp};;
          TF_VAR_target_db_srv_name* )  echo "export TF_VAR_target_db_srv_name=${DBSRVNAME:=${TF_VAR_target_db_srv_name}}"   >> .new_env-vars_${stamp};;
          TF_VAR_com_port* )            echo "export TF_VAR_com_port=${COMPORT:=${TF_VAR_com_port}}"                         >> .new_env-vars_${stamp};;
          TF_VAR_URL_ORDS_file* )       echo "export TF_VAR_URL_ORDS_file=${URLORDS:=${TF_VAR_URL_ORDS_file}}"               >> .new_env-vars_${stamp};;
          TF_VAR_URL_APEX_file* )       echo "export TF_VAR_URL_APEX_file=${URLAPEX:=${TF_VAR_URL_APEX_file}}"               >> .new_env-vars_${stamp};;
          TF_VAR_region* )              echo "export TF_VAR_region=${PRIMARY:=${TF_VAR_region}}"                             >> .new_env-vars_${stamp};;
          TF_VAR_dr_region*)            echo "export TF_VAR_dr_region=${STANDBY:=${TF_VAR_dr_region}}"                       >> .new_env-vars_${stamp};;
          TF_VAR_APEX_install_mode* )   echo "export TF_VAR_APEX_install_mode=${APEXINSTMODE:=${TF_VAR_APEX_install_mode}}"  >> .new_env-vars_${stamp};;
          * )                           echo "$line"                                                                         >> .new_env-vars_${stamp}
        esac
      elif echo ${i} | grep '^PathToYour*' > /dev/null ; then
        case "$i" in
          PathToYourSshPublicKey* )     echo "PathToYourSshPublicKey=${SSHPUBKEYPATH:=${PathToYourSshPublicKey}}"            >> .new_env-vars_${stamp};;
          PathToYourSshPrivateKey* )    echo "PathToYourSshPrivateKey=${SSHPRIVKEYPATH:=${PathToYourSshPrivateKey}}"         >> .new_env-vars_${stamp};;
          PathToYourApiPrivateKey* )    echo "PathToYourApiPrivateKey=${APIPRIVKEYPATH:=${PathToYourApiPrivateKey}}"         >> .new_env-vars_${stamp};;
        esac
      fi
    else
      echo "$line" >> .new_env-vars_${stamp}
    fi
  done < env-vars
else
  echo "PathToYourSshPublicKey=${SSHPUBKEYPATH:=${PathToYourSshPublicKey}}"            >> env-vars
  echo "PathToYourSshPrivateKey=${SSHPRIVKEYPATH:=${PathToYourSshPrivateKey}}"         >> env-vars
  echo "PathToYourApiPrivateKey=${APIPRIVKEYPATH:=${PathToYourApiPrivateKey}}"         >> env-vars
  echo "export TF_VAR_tenancy_ocid=${TENANCYID:=${TF_VAR_tenancy_ocid}}"               >> env-vars
  echo "export TF_VAR_user_ocid=${USERID:=${TF_VAR_user_ocid}}"                        >> env-vars
  echo "export TF_VAR_fingerprint=${FINGERPRINT:=${TF_VAR_fingerprint}}"               >> env-vars
  echo "export TF_VAR_compartment_ocid=${CID:=${TF_VAR_compartment_ocid}}"             >> env-vars
  echo "export TF_VAR_target_db_ip=${DBHOSTIP:=${TF_VAR_target_db_ip}}"                >> env-vars
  echo "export TF_VAR_target_db_srv_name=${DBSRVNAME:=${TF_VAR_target_db_srv_name}}"   >> env-vars
  echo "export TF_VAR_region=${REGION:=${TF_VAR_region}}"                              >> env-vars
  echo "export TF_VAR_com_port=${COMPORT:=${TF_VAR_com_port}}"                         >> env-vars
  echo "export TF_VAR_URL_ORDS_file=${URLORDS:=${TF_VAR_URL_ORDS_file}}"               >> env-vars
  echo "export TF_VAR_URL_APEX_file=${URLAPEX:=${TF_VAR_URL_APEX_file}}"               >> env-vars
  echo "export TF_VAR_APEX_install_mode=${APEXINSTMODE:=${TF_VAR_APEX_install_mode}}"  >> env-vars
  echo "export TF_VAR_private_key_path=\${PathToYourApiPrivateKey}"                    >> env-vars
  echo "export TF_VAR_ssh_public_key_file=\${PathToYourSshPublicKey} 2>/dev/null)"          >> env-vars
  echo "export TF_VAR_ssh_private_key_file=\${PathToYourSshPrivateKey} 2>/dev/null)"        >> env-vars
  echo "export TF_VAR_api_private_key=\${PathToYourApiPrivateKey} 2>/dev/null)"        >> env-vars
  echo "export TF_VAR_target_db_name=\`echo \$TF_VAR_target_db_srv_name|awk -F. '{print \$1}'\`" >> env-vars
  echo "export TF_VAR_dr_region=${STANDBY:=${TF_VAR_dr_region}}"                       >> env-vars
fi

### Checking retrun code
if [ $? -eq 0 ];then

  rm env-vars
  mv .new_env-vars_${stamp} env-vars
  rm .env-vars_*_${stamp}
  echo ""
  echo "INFO: env-vars is updated successfully."
  echo "      Pleaes set environment variables. (ex. source env-vars)"
else
  rm .new_env-vars_${stamp} .env-vars_*_${stamp}
  echo ""
  echo "INFO: Failed to update env-vars file, please retry after renaming env-vars. (ex. mv env-vars env-vars_back)"
fi

