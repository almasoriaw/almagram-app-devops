# Udagram - Instagram Clone on AWS

![Almagram Infrastructure Diagram](./images/aws_infrastructure_diagram_udagram.jpg)

This project implements a high-availability deployment for "Almagram", an Instagram-like application, using AWS CloudFormation for Infrastructure as Code (IaC).

## Project Structure

The project is structured into the following folders:

* `templates`: Contains the CloudFormation templates for the infrastructure.
* `parameters`: Contains parameter files for the CloudFormation templates.
* `scripts`: Contains scripts for automating the deployment and teardown of the CloudFormation stacks.
* `images`: Contains diagrams and screenshots of the infrastructure.

## Deployment Instructions

To deploy the Almagram infrastructure (previously named "Udagram", then renamed "Almagram), follow these steps:

1. Clone this repository to your local workspace.
2. Review the CloudFormation templates in the `templates` folder and parameter files in the `parameters` folder.
3. Make any necessary adjustments to the templates or parameter files based on your requirements.
4. Navigate to the `scripts` folder and use the provided scripts for deployment:

   ```bash
   # Deploy both network and application stacks
   ./deploy.sh
   
   # Or deploy individual stacks
   ./create.sh udagram-network ../templates/network.yml ../parameters/network-parameters.json
   ./create.sh udagram-app ../templates/udagram.yml ../parameters/udagram-parameters.json
   ```

5. To update existing stacks:
   ```bash
   ./update.sh udagram-network ../templates/network.yml ../parameters/network-parameters.json
   ./update.sh udagram-app ../templates/udagram.yml ../parameters/udagram-parameters.json
   ```

6. To delete the stacks when you're done:
   ```bash
   ./delete.sh udagram-app
   ./delete.sh udagram-network
   ```

## Features

The Almagram infrastructure includes the following features:

* High-availability deployment of web servers using Auto Scaling Groups and Elastic Load Balancers
* Secure storage of static content using Amazon S3
* Custom designed modern UI with Instagram-like interface
* IAM roles configured for EC2 instances to interact with S3
* CloudFront distribution for optimized content delivery

## Future Improvements

The following enhancements are planned for future iterations of this project:

* **Personal Photo Integration**: Currently, the code attempts to upload and display a personal photo as one of the feed items. While the upload to S3 is successful (verified by S3 console), there are display issues with the image in the front-end application. This will be resolved by investigating the variable substitution mechanism in the CloudFormation templates.

* **Database Integration**: Add a proper database backend (such as RDS or DynamoDB) for storing user information and post metadata.

* **User Authentication**: Implement user authentication via Amazon Cognito to allow for secure user login and registration.

* **CI/CD Pipeline**: Implement a full CI/CD pipeline using AWS CodePipeline and AWS CodeBuild for automated deployments.

* **Monitoring and Alerts**: Add CloudWatch alarms and dashboards for monitoring the infrastructure.

## Getting Started

### Dependencies

1. AWS CLI installed and configured in your workspace using an AWS IAM role with Administrator permissions (as reviewed in the course).

2. Access to a diagram creator software of your choice. I chose to use https://www.lucidchart.com/pages
 
3. Your favorite IDE or text editor ready to work. I chose to use Visual Studio https://visualstudio.microsoft.com/vs/

### Installation

You can get started by cloning this repo in your local workspace:

```
git clone https://github.com/almasoriaw/almagram-app-devops.git
```

## Testing

No tests required for this project.

## Project Instructions

1. Design your solution diagram using a tool of your choice and export it into an image file.

2. Add all the CloudFormation networking resources and parameters to the `network.yml` and `network-parameters.json` files inside the `starter` folder of this repo or create a folder of your preference.

3. Add all the CloudFormation application resources and parameters to the `udagram.yml` and `udagram-parameters.json` files inside the `starter` folder of this repo or create a folder of your preference.

4. Create any required script files to automate spin up and tear down of the CloudFormation stacks, you can use my `run.sh` script located inside the `scripts` folder. 

5. Copy and update the README.md file in the `starter` folder with creation and deletion instructions, as well as any useful information regarding your solution or create a folder of your preference..
   
6.  Submit your solution as a GitHub link or a zipped file containing the diagram image, CloudFormation yml and json files, automation scripts and README file.

## License

[License](LICENSE.txt)
