#The objective of this project is to deploy an EC2 instance in our default VPC with a script to install and start Jenkins. 
#We then need to create a private S3 bucket for any Jenkins artifacts.

#launch the ec2 instance and install website
resource "aws_instance" "myInstance" {
  ami                    = data.aws_ami.amzn2.id   #"ami-026ebd4cfe2c043b2" 
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]   #so that this instance is associated with this security group
  key_name               = var.key_name
  #user_data              = file("${path.cwd}/install_jenkins.sh")
  #user_data              = "${file(install_jenkins.sh)}"
  #user_data              = file(var.path)
  #user_data              = "${abspath(path.root)}/install_jenkins.sh"
  #user_data              = file("install_jenkins.sh")
 
  user_data = <<-EOF
    #!/bin/bash
    yum -y install httpd
    echo "<h1>Hello, World</h1>" > /var/www/html/inndex.html
    sudo systemctl enable httpd
    sudo systemctl start httpd
    EOF

  tags = {
    Name = "terraform_web_server_new"
  }
}

#create a private S3 bucket
resource "aws_s3_bucket" "bucketterraform" {
  bucket = "ola-terraform-buck3t" #name must be globally unique

  tags = {
    Name        = "Ola terraform bucket"
    Environment = "Dev"
  }
}

output "DNS" {
  value = aws_instance.myInstance.public_dns
}

