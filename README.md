# Customer Access Management

Django Application to enable Feedzai Employees to manage customers access to Feedzai Documentation.

1. [Getting Started](#getting-started)
    1. [Prerequisites](#prerequisites)
        1. [Terraform](#terraform)
        2. [Ansbile](#ansible)
    2. [Deploy](#deploy)
        1. [Download Source Code](#download-source-code)
        2. [Install pip3 packages](#install-pip3-packages)
        3. [AWS Credentials](#aWS-credentials)
        4. [Deploy Application](#deploy-application)



## Getting Started

The procedure described here assumes you are running it on a fresh installation of Ubuntu 20.04.

### Prerequisites

#### Terraform

```bash
# Reference -> https://www.terraform.io/docs/cli/install/apt.html
# Repository Configuration
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Terraform installation
sudo apt install terraform

```

#### Ansible
```bash
# Reference -> https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible

# Ansible aws_ec2 Plugin
# Reference -> https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws_ec2_inventory.html
sudo ansible-galaxy collection install amazon.aws
```

## Deploy

### Download Source Code

```bash
git clone --recursive https://github.com/jonasduarte/bidnamic-tf.git
```

### Install pip3 packages

```bash
sudo apt install python3-pip
pip3 install awscli boto3
```

### AWS Credentials
Terraform will use the aws profile "default", unless you pass a different one when invoking Terraform.

Since it uses boto3, you need to export AWS Credentials variables.

```bash
export AWS_SECRET_KEY=Secret
export AWS_ACCESS_KEY=Key
```

### Deploy Application
Inside the application root folder, execute the following command:
```bash
terraform init
```

If you are using AWS profile "default", execute the following:
```bash
terraform apply
```

Or, if you want to use a different profile, execute the following (replace "AWSPROFILE" for the desired profile):
```bash
terraform apply -var="profile=AWSPROFILE"
```
