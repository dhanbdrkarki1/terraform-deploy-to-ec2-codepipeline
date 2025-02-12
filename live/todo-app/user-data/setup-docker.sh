#!/bin/bash

# Update system
yum update -y

# Install required packages
yum install -y wget ruby

# Install CodeDeploy agent
cd /home/ec2-user
wget https://aws-codedeploy-us-east-2.s3.us-east-2.amazonaws.com/latest/install
chmod +x ./install
./install auto
systemctl start codedeploy-agent
systemctl enable codedeploy-agent

# install Docker
yum install -y docker

# Start and enable Docker service
systemctl start docker
systemctl enable docker

# Allow ec2-user to run Docker without sudo
usermod -aG docker ec2-user

echo "Setup complete!"