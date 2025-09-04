provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "one" {
  count                  = 4
  ami                    = "ami-0360c520857e3138f"
  instance_type          = "t2.medium"
  key_name               = "terakey"
  subnet_id              = ["subnet-0f225190304d7eb70"]
  vpc_security_group_ids = ["sg-077f3953a920d4e98"]
  tags = {
    Name = var.instance_names[count.index]
  }
}

variable "instance_names" {
  default = ["jenkins", "tomcat-1", "tomcat-2", "Monitoring server"]
}
