#!/bin/bash

# Main deployment script for Udagram Infrastructure

# Set environment variables
export AWS_REGION="us-east-1"
NETWORK_STACK_NAME="udagram-network"
APP_STACK_NAME="udagram-app"

# Define paths to templates and parameters
TEMPLATES_DIR="../templates"
PARAMS_DIR="../parameters"
NETWORK_TEMPLATE="$TEMPLATES_DIR/network.yml"
NETWORK_PARAMS="$PARAMS_DIR/network-parameters.json"
APP_TEMPLATE="$TEMPLATES_DIR/udagram.yml"
APP_PARAMS="$PARAMS_DIR/udagram-parameters.json"

# Function to print a section header
print_section() {
    echo "========================================================="
    echo "  $1"
    echo "========================================================="
}

# Display banner
print_section "Udagram Infrastructure Deployment"
echo "Region: $AWS_REGION"

# Check if the templates and parameters exist
if [ ! -f "$NETWORK_TEMPLATE" ] || [ ! -f "$NETWORK_PARAMS" ] || [ ! -f "$APP_TEMPLATE" ] || [ ! -f "$APP_PARAMS" ]; then
    echo "Error: Required template or parameter files not found."
    echo "Please make sure the following files exist:"
    echo "  - $NETWORK_TEMPLATE"
    echo "  - $NETWORK_PARAMS"
    echo "  - $APP_TEMPLATE"
    echo "  - $APP_PARAMS"
    exit 1
fi

# Ask user what action to perform
echo "What would you like to do?"
echo "1. Deploy infrastructure (create new stacks)"
echo "2. Update existing infrastructure"
echo "3. Delete infrastructure"
echo "4. Deploy network stack only"
echo "5. Deploy application stack only"
echo "6. Check stack status"
read -p "Enter your choice (1-6): " USER_CHOICE

case $USER_CHOICE in
    1)
        print_section "Deploying Network Stack"
        ./create.sh $NETWORK_STACK_NAME $NETWORK_TEMPLATE $NETWORK_PARAMS $AWS_REGION
        
        print_section "Deploying Application Stack"
        ./create.sh $APP_STACK_NAME $APP_TEMPLATE $APP_PARAMS $AWS_REGION
        ;;
    2)
        print_section "Updating Network Stack"
        ./update.sh $NETWORK_STACK_NAME $NETWORK_TEMPLATE $NETWORK_PARAMS $AWS_REGION
        
        print_section "Updating Application Stack"
        ./update.sh $APP_STACK_NAME $APP_TEMPLATE $APP_PARAMS $AWS_REGION
        ;;
    3)
        read -p "Are you sure you want to delete the infrastructure? (y/n) " CONFIRM
        if [ "$CONFIRM" == "y" ]; then
            print_section "Deleting Application Stack"
            ./delete.sh $APP_STACK_NAME $AWS_REGION
            
            print_section "Deleting Network Stack"
            ./delete.sh $NETWORK_STACK_NAME $AWS_REGION
        else
            echo "Operation cancelled."
        fi
        ;;
    4)
        print_section "Deploying Network Stack Only"
        ./create.sh $NETWORK_STACK_NAME $NETWORK_TEMPLATE $NETWORK_PARAMS $AWS_REGION
        ;;
    5)
        print_section "Deploying Application Stack Only"
        ./create.sh $APP_STACK_NAME $APP_TEMPLATE $APP_PARAMS $AWS_REGION
        ;;
    6)
        print_section "Checking Stack Status"
        echo "Network Stack ($NETWORK_STACK_NAME):"
        aws cloudformation describe-stacks --stack-name $NETWORK_STACK_NAME --region $AWS_REGION --query "Stacks[0].StackStatus" --output text 2>/dev/null || echo "Stack does not exist"
        
        echo -e "\nApplication Stack ($APP_STACK_NAME):"
        aws cloudformation describe-stacks --stack-name $APP_STACK_NAME --region $AWS_REGION --query "Stacks[0].StackStatus" --output text 2>/dev/null || echo "Stack does not exist"
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

print_section "Deployment Script Completed"
