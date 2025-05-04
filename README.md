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

### Project Scenario

The company is creating an Instagram clone called Almagram, with requirements to deploy the application to AWS infrastructure using Infrastructure as Code. The implementation needed to provision the required infrastructure and deploy the application with the necessary supporting software.

Since the underlying network infrastructure is maintained by a separate team, independent stacks were created for the network infrastructure and the application itself. Infrastructure spin-up and tear-down are fully automated so teams can create and discard testing environments on demand.

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

3. **Practical Output Exports**: The CloudFormation application stack exports include:
   - The public URL of the LoadBalancer with http:// prefix for convenience
   - The CloudFront distribution URL for static content access

4. **Automation Scripts**: The entire infrastructure can be created and destroyed using scripts without UI interactions. The primary script is `run.sh` which manages all CloudFormation operations.

### Project Deliverables

#### Infrastructure Deployment

To deploy the Almagram infrastructure, follow these steps:

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
