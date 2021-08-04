# Get AMZ Linux AMI
data "aws_ssm_parameter" "amzlinux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create key-pair for logging into EC2
resource "aws_key_pair" "bd-key" {
  key_name   = "bd-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Configure the application servers security group
resource "aws_security_group" "app-sg" {
  name        = "app-sg"
  description = "EC2 Security Group for BD Application"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description     = "Allow HTTP from the application LB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.bd-lb-sg.id]
  }
  ingress {
    description = "Allow ssh from the Bidnamic Network"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bidnamic_network
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.base_tags
}

#Create EC2 (Application Server) on AZ1
resource "aws_instance" "app-server-1" {
  ami                         = data.aws_ssm_parameter.amzlinux.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.bd-key.key_name
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.app-sg.id]
  subnet_id                   = aws_subnet.public_az1.id

  tags = {
    Name        = join("_", ["app_server_az1", upper(var.environment), var.code_version])
    Environment = upper(var.environment)
    Version     = var.code_version
  }
  depends_on = [aws_key_pair.bd-key, aws_route_table_association.private_az1]

  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region} --instance-ids ${self.id}
ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible/flask-app.yml
EOF
  }
}

#Create EC2 (Application Server) on AZ2
resource "aws_instance" "app-server-2" {
  ami                         = data.aws_ssm_parameter.amzlinux.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.bd-key.key_name
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.app-sg.id]
  subnet_id                   = aws_subnet.public_az2.id

  tags = {
    Name        = join("_", ["app_server_az2", upper(var.environment), var.code_version])
    Environment = upper(var.environment)
    Version     = var.code_version
  }
  depends_on = [aws_key_pair.bd-key, aws_route_table_association.private_az2]

  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region} --instance-ids ${self.id}
ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible/flask-app.yml
EOF
  }
}
