  #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    echo "Hello, World from PCIT Solutions at $(hostname -f)" > /var/www/html/index.html  #this helps us see the instance its connected to for load balance check
    sudo systemctl enable httpd
    sudo systemctl start httpd