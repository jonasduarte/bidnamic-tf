import os
import subprocess
import sys
import argparse



def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("--version", default="latest", help="Input code version. (Default: latest)")
    parser.add_argument("--profile", default="default", help="Input AWS Profile. (Default: default)")
    parser.add_argument("--secret", required=True, help="Input AWS Secret Key.")
    parser.add_argument("--access", required=True, help="Input AWS Access Key.")

    args = parser.parse_args()

    return args



def Print_Result(exec_code, command, output):
    if exec_code == 0:
        msg = "Successfully executed command: " + command
    else:
        msg = "An error has occurred while executing: " + command + "\n" "Command output is: "+ output
    print(msg)


def Terraform():
    Terraform_Dir = os.path.dirname(os.path.realpath(__file__)) + "/terraform"
    Terraform_Init = "terraform init -reconfigure"
    Terraform_Apply = "terraform apply -auto-approve " + '-var="code_version=' + parse_args().version + '" ' + '-var="profile=' + parse_args().profile + '"'

    Terraform_Init_Return = subprocess.Popen(Terraform_Init, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, cwd=Terraform_Dir)
    output, error = Terraform_Init_Return .communicate()
    output = output.decode("utf-8")
    Print_Result(Terraform_Init_Return.returncode, Terraform_Init, output)
    if Terraform_Init_Return.returncode != 0:
        sys.exit()

    Terraform_Apply_Return = subprocess.Popen(Terraform_Apply, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, cwd=Terraform_Dir)
    output, error = Terraform_Apply_Return.communicate()
    output = output.decode("utf-8")
    Print_Result(Terraform_Apply_Return.returncode, Terraform_Apply, output)
    if Terraform_Apply_Return.returncode != 0:
        sys.exit()


def Ansible():
    Ansible_Dir = os.path.dirname(os.path.realpath(__file__)) + "/ansible"

    os.environ["ANSIBLE_CONFIG"] = Ansible_Dir + "/ansible.cfg"

    Ansible_Command = "ansible-playbook --extra-vars 'passed_in_hosts=tag_Application_Challenge' " + Ansible_Dir + "/flask-app.yml"

    print(Ansible_Command)

    Ansible_Command_Return = subprocess.Popen(Ansible_Command, shell=True, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, cwd=Ansible_Dir)
    output, error = Ansible_Command_Return.communicate()
    output = output.decode("utf-8")
    Print_Result(Ansible_Command_Return.returncode, Ansible_Command, output)
    if Ansible_Command_Return.returncode != 0:
        sys.exit()


if __name__ == '__main__':

    os.environ["AWS_SECRET_ACCESS_KEY"] = parse_args().secret
    os.environ["AWS_ACCESS_KEY_ID"] = parse_args().access
    Terraform()
    Ansible()
