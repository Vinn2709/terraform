provider "aws" {
  region = "us-east-2"
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "TaskVPC"
  }
}

# Create Security Group
resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

  // Inbound rules (example rules, customize as needed)
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Outbound rules (example rules, customize as needed)
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySecurityGroup"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"  # Adjust the CIDR block as needed
  availability_zone       = "us-east-2a"   # Choose the desired availability zone
  map_public_ip_on_launch = true

  tags = {
    Name = "MySubnet"
  }
}
# Create EC2 instance
resource "aws_instance" "my_ec2_instance" {
  ami             = "ami-0cd3c7f72edd5b06d"  # Amazon Linux 2 AMI ID, change as needed
  instance_type   = "t2.micro"
  key_name        = "jan"  # Replace with your key pair name
  subnet_id       = aws_subnet.my_subnet.id  # Reference to the VPC created above
  vpc_security_group_ids = [aws_security_group.my_security_group.id]  # Use "vpc_security_group_ids" instead of "security_group"

  tags = {
    Name = "MyEC2Instance"  # Set the desired name here
  }
}