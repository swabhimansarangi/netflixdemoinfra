provider "aws" {
  region = "us-east-1"
}

# Fetch Default VPC
data "aws_vpc" "default" {
  default = true
}

# Create a Security Group
resource "aws_security_group" "allow_ssh_http_jenkins" {
  name        = "allow_ssh_http_jenkins"
  description = "Allow SSH, HTTP, HTTPS, Jenkins/Tomcat"
  vpc_id      = data.aws_vpc.default.id

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins / Tomcat (8080)
  ingress {
    description = "Jenkins/Tomcat"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound (all traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http_jenkins"
  }
}

# EC2 Instances
resource "aws_instance" "one" {
  count                  = 4
  ami                    = "ami-00ca32bbc84273381"
  instance_type          = "t2.medium"
  key_name               = "terakey"
  vpc_security_group_ids = [aws_security_group.allow_ssh_http_jenkins.id]

  tags = {
    Name = var.instance_names[count.index]
  }
}

# Variable for instance names
variable "instance_names" {
  default = ["jenkins", "tomcat-1", "tomcat-2", "Monitoring server"]
}
