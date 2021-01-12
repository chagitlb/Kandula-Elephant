
sudo apt-get update -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
mkdir -p "/home/ubuntu/jenkins_home"
sudo chown -R 1000:1000 "/home/ubuntu/jenkins_home"
sleep 60
sudo docker run -d --restart=always -p 8080:8080 -p 50000:50000 -v /home/ubuntu/jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock --env JAVA_OPTS='-Djenkins.install.runSetupWizard=false' jenkins/jenkins"
