#!/bin/sh -x

instance_name="docker-vm"
instance_type="e2-medium"
gcp_zone="us-central1-a"
gcp_project="<project-id>"
service_account="<sa-email>"

if [ ! -z "$1" ]; then
  instance_name=$1
fi

echo "creating instance $instance_name"

gcloud compute instances create $instance_name \
--zone=$gcp_zone \
--machine-type=$instance_type \
--network-interface=subnet=default,no-address \
--metadata=enable-oslogin=true \
--maintenance-policy=MIGRATE \
--provisioning-model=STANDARD \
--scopes=https://www.googleapis.com/auth/cloud-platform \
--create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/ubuntu-os-cloud/global/images/ubuntu-2004-focal-v20220905,mode=rw,size=20,type=projects/$gcp_project/zones/$gcp_zone/diskTypes/pd-balanced \
--shielded-secure-boot \
--shielded-vtpm \
--shielded-integrity-monitoring \
--metadata-from-file=startup-script=vm-startup-script.sh \
--service-account=$service_account



