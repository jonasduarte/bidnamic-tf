# Bidnamic Technical Challenge

Deploy the minimal flask app using Infrastructure as Code (IAC) technologies.

Minimal Flask app -> https://flask.palletsprojects.com/en/1.1.x/quickstart/#a-minimal-application

1. [Getting Started](#getting-started)
    1. [Prerequisites](#prerequisites)
        1. [Terraform](#terraform)
        2. [Ansbile](#ansible)
    2. [Deploy](#deploy)
        1. [Download Source Code](#download-source-code)
        2. [Install pip3 packages](#install-pip3-packages)
        3. [AWS Credentials](#aWS-credentials)
        4. [Deploy Application](#deploy-application)
        5. [Usage](#usage)



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
Terraform will use the aws profile "default". however you may use a different one. See -> [Usage](#usage)

### Deploy Application
Inside the application root folder, execute the following command:
```bash
python3 deploy-bd.py --aws-secret-key SECRET-KEY --aws-access-key ACCESS-KEY
```

### Usage

For more info run it with the `-h` flag

```bash
usage: deploy-bd.py [-h] [--version VERSION] [--profile PROFILE] --secret SECRET --access ACCESS

optional arguments:
  -h, --help         show this help message and exit
  --version VERSION  Input code version. (Default: latest)
  --profile PROFILE  Input AWS Profile. (Default: default)
  --secret SECRET    Input AWS Secret Key.
  --access ACCESS    Input AWS Access Key.

```
