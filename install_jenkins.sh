#The next file we will create is our install_jenkins.sh file. 
#This is what will be bootstrapped to the EC2 instance.

#!/bin/bash
sudo yum update -y
sudo yum -y install unzip wget tree git
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo yum install java-1.8.0-amazon-corretto-devel -y
# Add required dependencies for the jenkins package
sudo yum install jenkins -y
sudo systemctl daemon-reload
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
