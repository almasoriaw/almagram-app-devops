<div align="center">

# Almagram

[![Product Name Screen Shot][product-screenshot]](./images/almagram.jpg)

  <h3 align="center">High-Availability Instagram Clone on AWS</h3>

  <p align="center">
    A scalable, resilient Instagram-like application deployed using CloudFormation IaC
    <br />
    <a href="https://github.com/almasoriaw/almagram-app-devops"><strong>Explore the docs »</strong></a>
    <br />
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#built-with">Built With</a></li>
    <li><a href="#infrastructure-architecture">Infrastructure Architecture</a></li>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#deployment">Deployment</a></li>
    <li><a href="#technical-implementation">Technical Implementation</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#license">License</a></li>
  </ol>
</details>

## About The Project

Almagram (previously named "Udagram") is an Instagram clone application deployed on AWS infrastructure using CloudFormation for Infrastructure as Code. This project implements a high-availability, fault-tolerant architecture following AWS best practices.

The project scenario involves a company creating an Instagram clone that requires:
- Infrastructure provisioned through code (no manual console configuration)
- Application deployed across multiple availability zones for high availability
- Network infrastructure and application resources separated into distinct stacks
- Automated infrastructure spin-up and tear-down for testing environments

![Almagram Infrastructure Diagram](./images/aws_infrastructure_diagram_udagram.jpg)

### Project Requirements

#### Infrastructure Diagram
The diagram above shows all the AWS resources deployed for this solution including:
- Network resources: VPC, subnets, Internet Gateway, NAT Gateways
- EC2 resources: Autoscaling group with EC2 instances, Load Balancer, Security Groups
- Static Content: S3 bucket with CloudFront distribution

#### Network and Server Configuration
- ✅ Deployed in US East (N. Virginia) region
- ✅ VPC with four subnets (2 public, 2 private) across two Availability Zones
- ✅ Internet and NAT gateways for proper connectivity
- ✅ Launch Templates creating an Auto Scaling Group of 4 Ubuntu servers
- ✅ Application Load Balancer exposing the application to the internet
- ✅ Bastion host in public subnet for secure administrative access

#### Static Content
- ✅ S3 bucket with public-read access for static content
- ✅ Server IAM Role with proper permissions for S3 access
- ✅ CloudFront distribution for optimized content delivery

#### Security Groups
- ✅ Load balancer security group allowing all public traffic (0.0.0.0/0) on port 80
- ✅ Web server security group allowing traffic only from the load balancer
- ✅ Bastion host security group with restricted SSH access

### CloudFormation Templates

1. **Separate Network and Application Templates**: Considering that a network team would typically be in charge of the networking resources, two separate templates were delivered:
   - `network.yml`: Contains all networking resources (VPC, subnets, gateways, etc.)
   - `udagram.yml`: Contains application-specific resources (servers, load balancer, bucket, etc.)

2. **Cross-Stack References**: The application template uses outputs from the networking template to identify the hosting VPC and subnets. This is implemented using CloudFormation exports and imports:

   ```yaml
   VpcId:
     Fn::ImportValue:
       !Sub "${ProjectName}-vpc-id"
   ```

3. **Practical Output Exports**: The CloudFormation application stack exports include:
   - The public URL of the LoadBalancer with http:// prefix for convenience
   - The CloudFront distribution URL for static content access

4. **Automation Scripts**: The entire infrastructure can be created and destroyed using scripts without UI interactions. The primary script is `run.sh` which manages all CloudFormation operations.

### Project Deliverables

#### Infrastructure Deployment

To deploy the Almagram infrastructure, follow these steps:

1. **Clone the repository**
   ```bash
   git clone https://github.com/almasoriaw/almagram-app-devops.git
   cd almagram-app-devops
   ```

2. **Review templates and parameters**
   - Network template: `templates/network.yml`
   - Network parameters: `parameters/network-parameters.json`
   - Application template: `templates/udagram.yml`
   - Application parameters: `parameters/udagram-parameters.json`

3. **Deploy the infrastructure**
   ```bash
   # Create both network and application stacks
   ./scripts/run.sh create
   
   # Use change sets for controlled deployments (recommended for production)
   ./scripts/run.sh deploy
   
   # Update existing stacks
   ./scripts/run.sh update
   
   # Delete all resources when done
   ./scripts/run.sh delete
   ```

#### Network Stack Outputs
![CloudFormation Stacks](./images/cloudformation_stacks.jpg)

The deployed stacks expose outputs including subnet IDs, VPC ID, security groups, and more that are used by the application stack.

#### Access the Application
After deployment, you can access the application through:

- The LoadBalancer URL (exported as stack output with http:// prefix)
- The CloudFront distribution for static content

### Launching the App

The deployed application features:

- **Modern Instagram-like UI**: Custom designed interface mimicking Instagram's features
- **High-availability infrastructure**: Deployed across multiple Availability Zones
- **Auto-scaling capabilities**: Handles traffic fluctuations automatically
- **Secure architecture**: Properly segmented network with least privilege access
- **Optimized content delivery**: Via CloudFront and S3

### Technical Implementation

- **EC2 Configuration**: Instances are provisioned in private subnets with a user data script that:
  - Installs and configures NGINX
  - Downloads sample images
  - Uploads images to S3
  - Creates the HTML for the Instagram-like interface
  - Configures proper permissions

- **Security Implementation**:
  - IAM roles with least privilege for EC2 to S3 access
  - Security groups restricting traffic flow
  - Private subnets for application servers
  - Public access only through load balancer

### Future Improvements

Planned enhancements for future iterations include:

- **Database Integration**: Add RDS or DynamoDB for storing user information and post metadata
- **User Authentication**: Implement secure login via Amazon Cognito
- **CI/CD Pipeline**: Create automated deployment pipeline with AWS CodePipeline and CodeBuild
- **Monitoring and Alerts**: Implement CloudWatch dashboards and alerts for operational visibility
- **Personal Photo Integration**: Fix current issues with personal photo display in the frontend

### Requirements

To work with this project, you'll need:

- AWS CLI installed and configured with administrator permissions
- Basic knowledge of AWS CloudFormation and infrastructure as code
- Git for repository management

## License

[License](LICENSE.txt)
