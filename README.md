# Deployment of Flask application on Amazon Fargate using Terraform

The project describe how to deploy a Flask application to Amazon Fargate using Terraform.
The application is using AWS Cognito for user authentication.
It is also able to send a message to AWS SQS when visiting specific URL. 
The message triggers an AWS lambda function.

The purpose of the project was to:
- learn how to deploy a Flask application to AWS
- familiarize myself with some AWS services and Python boto3 library
- learn about Terraform tool

## Terraform

Terraform files in the project are able to deploy and configure following AWS services:

- VPC - create VPC network
- IAM - create roles and policies
- ECS - deploy Fargate service
- Congito - user authentication
- SQS - create a queue
- CloudWatch - logs monitoring
- S3 - store Lambda function
- Lambda - function will be triggered by new message in SQS

## Setup

- Clone repository
- Create AWS configuration and credential file:
https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html
- Change `aws_region` variable in `terraform/0-variables.tf` according to your settings
- Initialize a Terraform working directory
```buildoutcfg
cd terraform
terraform init
```
- Deploy application
```buildoutcfg
terraform apply
```

**NOTE**

`terraform/0-variables.tf` and `flask_app/config.ini` contains some common settings.
Modification of one file requires the same change to be made to the other file.

## Usage

Open AWS ECS service and grab public IP address of deployed container.
Application is running on port `5008`

### Routes

Main page
```buildoutcfg
/
```

Login page. Credentials for Cognito user are defined in `flask_app/config.ini`
```buildoutcfg
/login
```

Protected page. It can be accessed only by logged in users
```buildoutcfg
/protected
```

Visiting this route will send a message to SQS. Then the message will trigger Lambda function
```buildoutcfg
/queue
```

### Logs

Logs are stored in AWS CloudWatch:

- application logs `/ecs/flask_app`
- Lamba function logs `/aws/lambda/triggered_by_queue`

## Technologies

- Python 3.8.0
- Terraform 0.12.21
- Flask 1.1.1
- boto3 1.12.17
- AWS
- Docker