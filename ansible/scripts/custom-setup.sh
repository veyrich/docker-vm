#!/bin/sh

#any one-shot custom setup required at startup

#GCS buckets can also be mounted via the usual /etc/fstab mechanism, i.e.
#
# [bucket-name]        /bucket-mount-point gcsfuse rw,user,dir_mode
#
# details on options at: https://github.com/GoogleCloudPlatform/gcsfuse/blob/master/docs/mounting.md

if [ ! -d /gcs/bucket-one ]
then
   mkdir -p /gcs/bucket-one
fi
gcsfuse -o allow_other -file-mode=777 -dir-mode=777 --implicit-dirs [bucket_one] /gcs/bucket-one

if [ ! -d /gcs/bucket-two ]
then
   mkdir -p /gcs/bucket-two
fi
gcsfuse -o allow_other -file-mode=777 -dir-mode=777 --implicit-dirs [bucket_two] /gcs/bucket-two

#record completion
date > /tmp/custom-setup-finished
