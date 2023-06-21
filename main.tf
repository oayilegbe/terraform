#Create VPC resource
resource "aws_vpc" "terraformVPC" {
  cidr_block            = "172.0.0.0/16"
  instance_tenancy      = "default"
  enable_dns_support    = "true"
  enable_dns_hostnames  = "true"

  tags = {
    Name = "terraformVPC"
  }
}

#create IGW so website can be accesible via internet
resource "aws_internet_gateway" "terraformIGW" {
  vpc_id = aws_vpc.terraformVPC.id 

  tags = { 
      Name = "terraformIGW"
   }
}


#Create route table
resource "aws_route_table" "terraformRT" {
  vpc_id = aws_vpc.terraformVPC.id 

  tags = { 
      Name = "terraformRT"
   } 
}

#Create Route Table
resource "aws_route" "terraformROUTE" {
  route_table_id = aws_route_table.terraformRT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.terraformIGW.id
}

#Create Route Table Asssociation with vpc_id
resource "aws_main_route_table_association" "terraformMainRTAssoc" {
  vpc_id = aws_vpc.terraformVPC.id 
  route_table_id = aws_route_table.terraformRT.id
}

#Create public subnets A, B & C
resource "aws_subnet" "terraformPublicSubnetA" {
  vpc_id                = aws_vpc.terraformVPC.id
  cidr_block            = "172.0.0.0/24"
  availability_zone     = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraformPublicSubnetA"
  }
}


resource "aws_subnet" "terraformPublicSubnetB" {
  vpc_id                = aws_vpc.terraformVPC.id
  cidr_block            = "172.0.1.0/24"
  availability_zone     = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraformPublicSubnetB"
  }
}


resource "aws_subnet" "terraformPublicSubnetC" {
  vpc_id                = aws_vpc.terraformVPC.id
  cidr_block            = "172.0.2.0/24"
  availability_zone     = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraformPublicSubnetC"
  }
}

#Create route table association for subnets
resource "aws_route_table_association" "terraformRTAssocA" {
  subnet_id       = aws_subnet.terraformPublicSubnetA.id
  route_table_id  = aws_route_table.terraformRT.id
}

resource "aws_route_table_association" "terraformRTAssocB" {
  subnet_id       = aws_subnet.terraformPublicSubnetB.id
  route_table_id  = aws_route_table.terraformRT.id
}

resource "aws_route_table_association" "terraformRTAssocC" {
  subnet_id       = aws_subnet.terraformPublicSubnetC.id
  route_table_id  = aws_route_table.terraformRT.id
}

#Create an Application Load balancer
resource "aws_lb" "terraformALB" {
  name = "terraformALB"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.web_serverSG.id]
  subnets = [aws_subnet.terraformPublicSubnetA.id, aws_subnet.terraformPublicSubnetB.id, aws_subnet.terraformPublicSubnetC.id]
}

#Create a target group
resource "aws_lb_target_group" "terraformTG" {
  name ="terraformTG"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.terraformVPC.id
}

#Create alb listener
resource "aws_alb_listener" "terraformALBListener" {
  load_balancer_arn = aws_lb.terraformALB.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.terraformTG.arn
  }
}


resource "aws_launch_template" "terraformLT" {
  name                    = "terraformLT"
  default_version         = 1
  description             = "Launch template used for provisioning with Terraform"
  image_id                = data.aws_ami.amzn2.id
  instance_type           = var.instance_type
  key_name                = var.key_name
  user_data               = filebase64("${path.module}/httpd.sh")
  network_interfaces {
    subnet_id = aws_subnet.terraformPublicSubnetA.id
    security_groups = [aws_security_group.web_serverSG.id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "terraformInstance"
    }
  }
}


#Create autoscaling group
resource "aws_autoscaling_group" "terraformASG" {
  name = "terraformASG"
  vpc_zone_identifier = [aws_subnet.terraformPublicSubnetA.id, aws_subnet.terraformPublicSubnetB.id, aws_subnet.terraformPublicSubnetC.id]
  desired_capacity = 2
  max_size = 3
  min_size = 2

  launch_template {
    id = aws_launch_template.terraformLT.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.terraformASG.id
  alb_target_group_arn = aws_lb_target_group.terraformTG.arn
}


output "ALB_DNS" {
  value = aws_lb.terraformALB.dns_name
}

