#!/bin/bash

# Change to the directory containing your Terraform configuration
cd ./terraform

# Initialize Terraform
terraform init

# Apply the Terraform configuration
terraform apply -auto-approve

# Extract the cluster name from the Terraform output
cluster_name=$(terraform output -raw cluster_name)

# List the tasks in the cluster and extract the task ARN
task_arn=$(aws ecs list-tasks --cluster "$cluster_name" --query 'taskArns[0]' --output text)

# Describe the task to get the network interface ID
network_interface_id=$(aws ecs describe-tasks --cluster "$cluster_name" --tasks "$task_arn" --query 'tasks[].attachments[].details[] | [?name==`networkInterfaceId`].value' --output text)

# Describe the network interface to get the public IP address
public_ip=$(aws ec2 describe-network-interfaces --network-interface-ids "$network_interface_id" --query 'NetworkInterfaces[].Association.PublicIp' --output text)

# Use curl to send a request to your service
curl http://"$public_ip":80

# echo command to terminal
echo "curl http://$public_ip:80"
