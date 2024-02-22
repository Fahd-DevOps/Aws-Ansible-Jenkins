#!/bin/bash

# Placeholders values
REGION="us-east-1"
AMI="ami-0c7217cdde317cfec"  # Linux AMI ID
INSTANCE_TYPE="t2.micro"
KEY_NAME="ec2_key_jenkins"
SECURITY_GROUP_NAME="jenkins-security-group"
DESCRIPTION="Allows SSH and Jenkins traffic"
INSTANCE_NAME="jenkins-instance"

# Create security group and capture security group ID
SG_ID=$(aws ec2 create-security-group \
    --group-name $SECURITY_GROUP_NAME \
    --description "$DESCRIPTION" \
    --region $REGION \
    --output text \
    --query 'GroupId')

# Add SSH rule
aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0 > /dev/null  # Replace with your allowed IP range

# Add Jenkins rule
aws ec2 authorize-security-group-ingress \
    --group-id $SG_ID \
    --protocol tcp \
    --port 8080 \
    --cidr 0.0.0.0/0 > /dev/null  # Replace with your allowed IP range

# EC2 instance creation with a name tag
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id $AMI \
    --count 1 \
    --instance-type $INSTANCE_TYPE \
    --key-name $KEY_NAME \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
    --region $REGION \
    --output text \
    --query 'Instances[0].InstanceId')

# Wait for the instance to be running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Get the public IP address
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --region $REGION \
    --output text \
    --query 'Reservations[0].Instances[0].PublicIpAddress')

echo "Instance $INSTANCE_NAME ($INSTANCE_ID) created with public IP: $PUBLIC_IP"

