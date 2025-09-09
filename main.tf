provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "one" {
  count                  = 4
  ami                    = "ami-00ca32bbc84273381"
  instance_type          = "t2.medium"
  key_name               = "terakey"
  vpc_security_group_ids = ["sg-0ac21d17e11ed61ba"]
  tags = {
    Name = var.instance_names[count.index]
  }
}

variable "instance_names" {
  default = ["jenkins", "tomcat-1", "tomcat-2", "Monitoring server"]
}
