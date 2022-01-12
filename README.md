# Building Jenkins Server

1. Launch EC2 instance on AWS
2. SSH into on bash


## Install Java on Jenkins EC2 Server
- https://www.digitalocean.com/community/tutorials/how-to-install-java-with-apt-on-ubuntu-18-04#installing-specific-versions-of-openjdk

3. Install below java dependencies

```
sudo apt update
sudo apt install default-jre
java --version
sudo apt install default-jdk
javac --version
```

## Installing Jenkins
- https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-18-04

4. Run following code to install dependencies:

```
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt install jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
sudo ufw allow 8080  #opens port 8080
sudo ufw status

```

5. If firewall is inactive run below code 

```
sudo ufw allow OpenSSH
sudo ufw enable
```
6. Go to http://your_server_ip_or_domain:8080 on browser
7. Admin password - `sudo cat /var/lib/jenkins/secrets/initialAdminPassword`
8. Continue with account setup and install suggested plugins 

## Install plugins
- Node, Git, Terraform, Ansible

## Terraform in Jenkins 

- Terraform plugin
- Add AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_DEFAULT_REGION=eu-west-1
- create new jenkins job
- Configure jobs as below