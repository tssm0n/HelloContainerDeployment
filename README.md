Hello (World) Container Deployment
==========================

AWS CloudFormation template for deploying and scaling a simple Docker container.

Contents:
* ecs.yml - The CloudFormation template to create the necessary resources
* deploy.sh - Wrapper script for the AWS cli to create the CloudFormation stack
* teardown.sh - Wrapper script for the AWS cli to delete the CloudFormation stack

Requirements:
* An existing AWS VPC
* A single Subnet in the AWS VPC
* A keypair for your EC2 instances

Resources Created:
* ECS Cluster and Service for deploying a Docker container
* Elastic Load Balancer
* Autoscaling Group with
  * Launch Configuration
  * Scale up policy and alarm based on CPU usage
  * Scal down policy and alarm based on CPU usage
* IAM Roles for the EC2 instances and container instances
* Security Groups to enable communication between the containers and the load balancer

## Creating the resources using CloudFormation

There are two possible ways to create the CloudFormation stack.  Through the AWS Console UI, or using the AWS cli.

### AWS Console UI
* Log in to the AWS Console
* Select CloudFormation
* Click 'Create Stack'
* Under 'Choose Template' select 'Choose File' and select the ecs.yml file then click 'Next'
* Enter a stack name, then select values for: KeyName, VPCID and SubnetID
* Click Next, then follow the prompts, click 'I acknowledge that AWS CloudFormation might create IAM resources." and click 'Create'
* After the resources are created, check the 'Outputs' tab to find the URL for the load balancer
(the application runs on port 5000, so the URL will be http://[URL of the ELB]:5000)

### Command Line
The provided scripts utilize the AWS CLI.  You should have AWS access keys generated that have permissions to create CloudFormation, EC2, IAM and ECS resources.
Any additional parameters that are passed to the script are used as additional arguments to the AWS CLI.

* Run the deploy.sh script using the following syntax:
<div>
./deploy.sh --vpc aws-vpc-id --subnet aws-subnet-id --key aws-ec2-key [aws-cli-args]

For example:

./deploy.sh --vpc vpc-123456 --subnet subnet-123456 --key mykey --profile my_user --region us-east-1
</div>

The script will create the stack, output the status every 20 seconds, then print the URL to access the application. 

To delete the stack:
* Run teardown.sh
For example:
<div>
./teardown.sh --profile my_user --region us-east-1
</div>
