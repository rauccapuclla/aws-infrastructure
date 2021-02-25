resource "aws_security_group" "allow-ingress-traffic" {
  name = "allow-ingress"
  description = "DevOps tools sg"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "jenkins" {
  ami           = "ami-0302f3ec240b9d23c"
  instance_type = "t2.small"
  key_name = "demo"
  security_groups = ["${aws_security_group.allow-ingress-traffic.name}"]
  user_data = <<EOF
  #!/bin/bash
  docker run -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock --name jenkins jenkins/jenkins:lts
  yum -y install curl git unzip
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  ./aws/install
  curl -L "https://github.com/docker/compose/releases/download/1.28.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
  cd /tmp && git clone https://github.com/rauccapuclla/devops-docker.git
EOF
  tags = {
    Name = "jenkins-node"
  }
}
