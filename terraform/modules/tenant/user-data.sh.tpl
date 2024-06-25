#!/bin/bash

adduser ${provision_username} --disabled-password --gecos ""
mkdir -p /home/${provision_username}/.ssh
echo "${provision_public_key}" > /home/${provision_username}/.ssh/authorized_keys
echo "${provision_private_key}" > /home/${provision_username}/.ssh/id_ed25519
chmod 700 /home/${provision_username}/.ssh/
chmod 600 /home/${provision_username}/.ssh/authorized_keys /home/${provision_username}/.ssh/id_ed25519
chown -R ${provision_username}: /home/${provision_username}/.ssh/
echo "${provision_username}    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Add Docker's official GPG key
apt-get update
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo ${provision_version_code_name}) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

# Install Docker
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to Docker group
groupadd docker
usermod -aG docker ${provision_username}

# Automatically start Docker on boot
systemctl enable docker.service
systemctl enable containerd.service

# Install AWS CLI
apt-get install -y awscli

# Configure AWS access
aws configure set aws_access_key_id "${provision_aws_key}"
aws configure set aws_secret_access_key "${provision_aws_access_key}"
aws configure set region "${provision_aws_region}"
aws configure set output ""
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 637423460784.dkr.ecr.us-east-1.amazonaws.com

mkdir /home/${provision_username}/test_1

# Clone repo
su -c 'ssh -o StrictHostKeyChecking=no git@github.com' ${provision_username}
su -c 'git clone git@github.com:diywarrior/${provision_root_dir}.git /home/${provision_username}/${provision_root_dir}' ${provision_username}
su -c 'cd /home/${provision_username}/${provision_root_dir} && git pull origin ${provision_username}-devops-course' ${provision_username}
su -c 'cd /home/${provision_username}/${provision_root_dir} && git checkout ${provision_username}-devops-course' ${provision_username}
mkdir /home/${provision_username}/test_2

# Up the application
cd /home/${provision_username}/${provision_root_dir} && docker compose up -d
mkdir /home/${provision_username}/test_3