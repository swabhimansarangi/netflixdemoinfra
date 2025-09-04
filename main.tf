provider "aws" {
  region = "us-east-1"
}

# 👇 Data block: look up the VPC for your given subnet
data "aws_subnet" "selected" {
  id = "subnet-0f225190304d7eb70"  # your existing subnet
}

# 👇 Create a security group in the same VPC
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH, HTTP, HTTPS, Jenkins"
  vpc_id      = data.aws_subnet.selected.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # restrict to your IP for security
  }

  ingress {
    description = "Jenkins UI"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Jenkins accessible from browser
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}

# 👇 Your EC2 instances
resource "aws_instance" "one" {
  count         = 4
  ami           = "ami-0360c520857e3138f"
  instance_type = "t2.medium"
  key_name      = "terakey"

  subnet_id              = "subnet-0f225190304d7eb70"
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = var.instance_names[count.index]
  }
}

variable "instance_names" {
  default = ["jenkins", "tomcat-1", "tomcat-2", "Monitoring server"]
}
