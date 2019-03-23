output "jenkins_public_ip" {
  value = "${aws_instance.jenkins.public_ip}"
}

output "sonar_public_ip" {
  value = "${aws_instance.sonar.public_ip}"
}
