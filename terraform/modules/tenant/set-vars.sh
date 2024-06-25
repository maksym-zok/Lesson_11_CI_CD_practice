#!/bin/bash

export provision_username='mhlyva'
export provision_public_ssh_key=$(cat ~/.ssh/id_ed25519.pub)
export provision_private_ssh_key=$(cat ~/.ssh/id_ed25519)
export provision_aws_access_key_id=$(cat ~/.aws/credentials | grep aws_access_key_id | head -n 1 | awk '{ print $3 }')
export provision_aws_secret_access_key=$(cat ~/.aws/credentials | grep aws_secret_access_key | head -n 1 | awk '{ print $3 }')
export provision_aws_region=$(cat ~/.aws/config | grep region | head -n 1 | awk '{ print $3 }')
export provision_root_dir='devops_course'
export version_codename='$VERSION_CODENAME'

envsubst < 'user-data.sh.tpl' > 'user-data.sh'