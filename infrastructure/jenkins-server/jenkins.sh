#! /bin/bash
# update os
sudo yum update -y
# set server hostname as jenkins-server
sudo hostnamectl set-hostname jenkins-server
# install git
dnf install git -y
# install java 11
# sudo yum install -y amazon-linux-extras
sudo dnf install java-11-amazon-corretto -y
# install jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
# amazon-linux-extras install epel
sudo yum install jenkins -y
sudo systemctl daemon-reload
sudo systemctl start jenkins
sudo systemctl enable jenkins
# install docker
sudo dnf install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker jenkins
# configure docker as cloud agent for jenkins
sudo cp /lib/systemd/system/docker.service /lib/systemd/system/docker.service.bak
sudo sed -i 's/^ExecStart=.*/ExecStart=\/usr\/bin\/dockerd -H tcp:\/\/127.0.0.1:2375 -H unix:\/\/\/var\/run\/docker.sock/g' /lib/systemd/system/docker.service
sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl restart jenkins
# install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \ -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# uninstall aws cli version 1
sudo rm -rf /bin/aws
# install aws cli version 2
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo unzip awscliv2.zip
./aws/install
# install python 3
sudo yum install python3 -y
# install ansible
# sudo pip3 install ansible---yükleyemedim
# install boto3
# sudo pip3 install boto3--yükleyemedim
# install terraform
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform