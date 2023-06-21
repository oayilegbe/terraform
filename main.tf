#The objective of this project is to deploy an EC2 instance in our default VPC with a script to install and start Jenkins. 
#We then need to create a private S3 bucket for any Jenkins artifacts.

#launch the ec2 instance and install website
resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.amazon_linux_2.id     #"ami-026ebd4cfe2c043b2" 
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = var.key_name
  user_data              = file("${path.cwd}/install_jenkins.sh")
  #user_data              = "${file(install_jenkins.sh)}"
  #user_data              = file(var.path)
  #user_data              = "${abspath(path.root)}/install_jenkins.sh"
  #user_data              = file("install_jenkins.sh")
 
  /*
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y #Ensure that your software packages are up to date on your instance by using the following command to perform a quick software update:
    sudo wget -O /etc/yum.repos.d/jenkins.repo \https://pkg.jenkins.io/redhat-stable/jenkins.repo #Add the Jenkins repo using the following command:
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key #Import a key file from Jenkins-CI to enable installation from the package:
    sudo yum upgrade -y
    sudo yum install java-1.8.0-amazon-corretto-devel -y
    sudo yum install jenkins -y #Install Jenkins:
    sudo systemctl enable jenkins #Enable the Jenkins service to start at boot:
    sudo systemctl start jenkins #Start Jenkins as a service:
    sudo systemctl status jenkins
    EOF */

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

