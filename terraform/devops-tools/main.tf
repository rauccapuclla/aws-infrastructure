resource "aws_security_group" "jenkins-sg" {
  name = "jenkins-sg-allow"
  description = "Jenkins Security Group"

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

resource "aws_security_group" "sonar-sg" {
  name = "sonar-sg-allow"
  description = "Sonar Security Group"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9000
    to_port = 9000
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
  instance_type = "t2.micro"
  key_name = "demo"
  security_groups = ["${aws_security_group.jenkins-sg.name}"]
  user_data = <<EOF
  #!/bin/bash
  docker run -d -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock --name jenkins rauccapuclla/jenkins-docker:latest
EOF
  tags = {
    Name = "jenkins-node"
  }
}

resource "aws_instance" "sonar" {
  ami           = "ami-0302f3ec240b9d23c"
  instance_type = "t2.micro"
  key_name = "demo"
  security_groups = ["${aws_security_group.sonar-sg.name}"]
  user_data = <<EOF
  #!/bin/bash
  docker run -d -p 9000:9000 --name sonar sonarqube:lts
EOF
  tags = {
    Name = "sonar-node"
  }
}
