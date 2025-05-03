#!/bin/bash

# Script to delete a CloudFormation stack

# Check if all required parameters are provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <stack-name> [<region>]"
    echo "Example: $0 udagram-network us-east-1"
    exit 1
fi

STACK_NAME=$1
REGION=${2:-"us-east-1"} # Default to us-east-1 if no region is provided

echo "Deleting stack: $STACK_NAME"
echo "Region: $REGION"

# Delete the CloudFormation stack
aws cloudformation delete-stack \
    --stack-name $STACK_NAME \
    --region $REGION

# Wait for stack deletion to complete
echo "Waiting for stack deletion to complete..."
aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME --region $REGION

if [ $? -eq 0 ]; then
    echo "Stack deletion completed successfully!"
else
    echo "Stack deletion failed. Check the AWS CloudFormation console for details."
fi
