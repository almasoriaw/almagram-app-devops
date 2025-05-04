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

[product-screenshot]: ./images/almagram.jpg

## Built With

This project leverages several AWS services and technologies:

* ![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
* ![CloudFormation](https://img.shields.io/badge/CloudFormation-FFB71B.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
* ![EC2](https://img.shields.io/badge/EC2-F90.svg?style=for-the-badge&logo=amazon-ec2&logoColor=white)
* ![S3](https://img.shields.io/badge/S3-569A31.svg?style=for-the-badge&logo=amazon-s3&logoColor=white)
* ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
* ![NGINX](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)

<p align="right">(<a href="#top">back to top</a>)</p>

## Infrastructure Architecture

![Almagram Infrastructure Diagram](./images/aws_infrastructure_diagram_udagram.jpg)

### Architecture Components

#### Network Resources
* **VPC** with four subnets (2 public, 2 private) across two Availability Zones
* **Internet Gateway** and **NAT Gateways** for proper connectivity
* **Route Tables** configured for public and private subnet traffic

#### Compute & Scaling
* **Auto Scaling Group** with Launch Template for EC2 instances
* **Application Load Balancer** distributing traffic across multiple AZs
* **Bastion Host** in public subnet for secure administrative access

#### Content Delivery
* **S3 Bucket** with public-read access for static content storage
* **CloudFront Distribution** for optimized global content delivery
* **IAM Roles** providing EC2 instances permission to interact with S3

#### Security
* **Security Groups** implementing principle of least privilege
* **Private Subnets** for application tier isolation
* **IAM Permissions** ensuring proper access control

<p align="right">(<a href="#top">back to top</a>)</p>

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

* AWS CLI installed and configured with administrator permissions
  ```sh
  # Verify AWS CLI is installed
  aws --version
  
  # Configure AWS CLI with your credentials
  aws configure
  ```
* Git for repository management
* Basic knowledge of AWS CloudFormation and infrastructure as code

### Project Structure

This project is organized into the following directories:

```
almagram-app-devops/
├── images/                  # Screenshots and diagrams
├── parameters/              # CloudFormation parameter files
├── scripts/                 # Deployment automation scripts
├── starter/                 # Initial project templates
├── templates/               # CloudFormation templates
│   ├── network.yml          # Network infrastructure template
│   └── udagram.yml          # Application resources template
├── LICENSE.txt              # Project license
└── README.md                # Project documentation
```

### Template Design

The infrastructure is divided into two separate CloudFormation templates following industry best practices:

1. **Network Template** (`network.yml`):
   - VPC, subnets, Internet Gateway, NAT Gateways, route tables
   - Designed to be managed by a dedicated network team

2. **Application Template** (`udagram.yml`):
   - EC2 instances, Auto Scaling Group, Load Balancer, S3 bucket, IAM roles
   - References network resources using exports/imports

Template integration is achieved through CloudFormation exports and imports:

```yaml
VpcId:
  Fn::ImportValue:
    !Sub "${ProjectName}-vpc-id"
```

Output exports include convenient access URLs with proper prefixes:
```yaml
LoadBalancerDNSName:
  Value: !Join ["", ["http://", !GetAtt LoadBalancer.DNSName]]
```

<p align="right">(<a href="#top">back to top</a>)</p>

## Deployment

Follow these steps to deploy the Almagram infrastructure to AWS:

### 1. Clone the Repository

```bash
git clone https://github.com/almasoriaw/almagram-app-devops.git
cd almagram-app-devops
```

### 2. Review CloudFormation Templates & Parameters

* Network template: `templates/network.yml`
* Network parameters: `parameters/network-parameters.json`
* Application template: `templates/udagram.yml`
* Application parameters: `parameters/udagram-parameters.json`

### 3. Deploy the Infrastructure

The primary deployment tool is the `run.sh` script which manages all CloudFormation operations:

```bash
# Create all stacks
./scripts/run.sh create

# Deploy using change sets (recommended for production)
./scripts/run.sh deploy

# Update existing stacks
./scripts/run.sh update

# Delete all resources
./scripts/run.sh delete
```

### 4. Monitor Deployment

Once deployed, you can monitor your stacks in the AWS CloudFormation console:

![CloudFormation Stacks](./images/cloudformation_stacks.jpg)

### 5. Access the Application

After successful deployment, access the application through:

* The Load Balancer URL (exported as stack output)
* The CloudFront distribution URL for optimized content delivery

<p align="right">(<a href="#top">back to top</a>)</p>

## Technical Implementation

### Application Features

* **Modern Instagram-like UI**: Custom designed responsive interface with Instagram styling
* **Feed Display**: Shows user posts with images, likes, and comments
* **Interactive Elements**: Like buttons, comment areas, and navigation icons
* **User Profiles**: Avatar images and usernames for post attribution

### EC2 Instance Configuration

The EC2 instances are provisioned with a comprehensive bootstrap script that:

```bash
# Core software installation
apt-get update -y
sudo apt-get install nginx awscli -y
service nginx start

# Content preparation
mkdir -p /tmp/udagram-images
cd /tmp/udagram-images
# Download sample images...

# S3 integration
aws s3 cp /tmp/udagram-images/ s3://${S3Bucket}/ --recursive --acl public-read

# Front-end deployment
sudo cp index.html /var/www/html/
```

### Security Implementation

* **Defense in Depth**: Multiple layers of security controls
* **Network Segmentation**: Web servers in private subnets
* **Access Control**:
  * IAM roles with least privilege principle
  * Security groups restricting traffic paths
  * Load balancer as the only public entry point
* **Data Protection**: Encrypted S3 bucket with proper access policies

<p align="right">(<a href="#top">back to top</a>)</p>

## Roadmap

Planned enhancements for future iterations of this project:

- [ ] **Database Integration**: Add RDS or DynamoDB backend for user data and posts
- [ ] **User Authentication**: Implement secure authentication with Amazon Cognito
- [ ] **CI/CD Pipeline**: Create automated deployment using AWS CodePipeline and CodeBuild
- [ ] **Monitoring & Alerts**: Add CloudWatch dashboards and alarms for operational visibility
- [ ] **Personal Photo Integration**: Fix current issues with personal photo display in the frontend
- [ ] **Custom Domain**: Add Route 53 configuration with custom domain name
- [ ] **Enhanced Security**: Implement WAF for additional protection

See the [open issues](https://github.com/almasoriaw/almagram-app-devops/issues) for a full list of proposed features and known issues.

<p align="right">(<a href="#top">back to top</a>)</p>

## License

Distributed under the MIT License. See [LICENSE.txt](LICENSE.txt) for more information.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
