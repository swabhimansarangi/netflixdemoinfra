provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "one" {
  count                  = 4
  ami                    = "ami-0360c520857e3138f"
  instance_type          = "t2.medium"
  key_name               = "terakey"
  vpc_security_group_ids = ["sg-05d2c71975ecf391e"]
  tags = {
    Name = var.instance_names[count.index]
  }
}

variable "instance_names" {
  default = ["jenkins", "tomcat-1", "tomcat-2", "Monitoring server"]
}
