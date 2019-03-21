resource "aws_security_group" "jenkins-sg" {
  name = "jenkins-sg"
  description = "Jenkins security group"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

}
resource "aws_instance" "node" {
  ami           = "ami-0302f3ec240b9d23c"
  instance_type = "t2.micro"
  key_name = "demo"
  security_groups = ["${aws_security_group.jenkins-sg.id}"]
  user_data = <<EOF
  #!/bin/bash
  docker run -d -p 8080:8080 --name jenkins jenkins/jenkins:lts
EOF
  tags = {
    Name = "docker-node"
  }
}
resource "aws_ecr_repository" "devops-docker" {
  name = "devops-docker"
  tags = {
    Name = "docker-registry"
  }
}
