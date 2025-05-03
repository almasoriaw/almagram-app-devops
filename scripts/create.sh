#!/bin/bash

# Script to create a CloudFormation stack

# Check if all required parameters are provided
if [ $# -lt 3 ]; then
    echo "Usage: $0 <stack-name> <template-body> <parameters-file> [<region>]"
    echo "Example: $0 udagram-network ../templates/network.yml ../parameters/network-parameters.json us-east-1"
    exit 1
fi

STACK_NAME=$1
TEMPLATE_BODY=$2
PARAMETERS_FILE=$3
REGION=${4:-"us-east-1"} # Default to us-east-1 if no region is provided

echo "Creating stack: $STACK_NAME"
echo "Template: $TEMPLATE_BODY"
echo "Parameters: $PARAMETERS_FILE"
echo "Region: $REGION"

# Create the CloudFormation stack
aws cloudformation create-stack \
    --stack-name $STACK_NAME \
    --template-body file://$TEMPLATE_BODY \
    --parameters file://$PARAMETERS_FILE \
    --region $REGION \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

# Wait for stack creation to complete
echo "Waiting for stack creation to complete..."
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME --region $REGION

if [ $? -eq 0 ]; then
    echo "Stack creation completed successfully!"
    # Output the stack outputs
    aws cloudformation describe-stacks --stack-name $STACK_NAME --region $REGION --query "Stacks[0].Outputs" --output table
else
    echo "Stack creation failed. Check the AWS CloudFormation console for details."
fi
