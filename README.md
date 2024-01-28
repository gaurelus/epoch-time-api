# Epoch Time API Endpoint
---
This repository hosts the code and infrastructure setup for a simple API endpoint that returns the current epoch time. The API is developed using Flask, a lightweight Python web framework, and is containerized with Docker for seamless deployment and scalability.

## Repository Contents

- **Flask Application Code**: The core application code written in Python using the Flask framework.
- **Dockerfile**: Used for creating a Docker image of the application.
- **Terraform Configuration Files**: These files are used to provision the necessary AWS resources.
- **Deployment Script**: Automates the deployment process and provides the container service IP Address.
- **Requirements**: The python application libraries installed in the application

## API Details

The API responds to HTTP GET requests at the root endpoint (`/`) and returns a JSON payload in the format `{"The current epoch time": <EPOCH_TIME>}`, where `<EPOCH_TIME>` is an integer representing the current epoch time in seconds.

> **Disclaimer**: This is a basic implementation intended for demonstration purposes. Additional features or modifications may be necessary for a production environment.

## Prerequisites

To deploy this application, the following tools are required:

- **Terraform**: Used to provision and manage the AWS resources required for this application. Ensure Terraform is installed on your machine. It can be downloaded from the [official Terraform website](https://www.terraform.io/downloads.html). This project has been tested with Terraform version `v1.7.1`.
- **AWS CLI**: Used to interact with AWS services. Ensure AWS CLI is installed on your machine. It can be downloaded from the [official AWS CLI website](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html). This project has been tested with AWS CLI version 2.15.14.
---

### Download Git Repo


To install the application clone this git repository to a system with internet access:
```bash 
git clone https://github.com/gaurelus/epoch-time-api.git
```

### Login to AWS CLI

**Requires Admin Account Access**
To access cloud resources authenticate with the following command in your terminal:
```bash
aws configure
```
### Run the deploy.sh script

- navigate to source directory
```bash 
cd ./epoch-time-api/ 
```

- Change deploy script permissions for execution
```bash
chmod +x ./deploy.sh

- Deploy New applicaiton VPC and recieve new IP address for curl command
./deploy.sh
```
### Usage
Once the application is deployed, you can interact with it using HTTP GET requests. The application responds to requests at the root endpoint (/) and returns the current epoch time in a JSON payload.

Here’s an example of how to use curl to send a request to the application:

```bash
curl http://<PUBLIC_IP_ADDRESS>:80
```

The deployment script will provide you with the proper command and IP Address to access the hosted service.  The output will be a JSON object in the following format:
```json
{
  "The current epoch time": <EPOCH_TIME>
}
```
Where <EPOCH_TIME> is an integer representing the current epoch time in seconds.

Please note that the public IP address of your application is output by the deployment script. If you lose this IP address, you can rerun the deployment script to retrieve it.

> **WARNING**: This application uses a development server. Do not use it in a production deployment. Use a production WSGI server instead.

