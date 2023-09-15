# pythonapp
Jenkins Master Slave Setup

Prerequisites:

1. Launch 2 AWS EC2 Linux instances .
2. Configure Jenkins on an EC2 Linux instance which will act as Master Node.
3. Second EC2 Linux Server will act as a Slave Node for Jenkins.



Security group setting for both EC2 instances should be as follows.



Steps -
1. Install Java on master node
2. Install Jenkins on master node
3. Install java on slave node
4. Create a user and ssh keys on slave node
5. Copy keys on master node
6. Join slave node to master
7. Test the setup

Procedure -
1. Install java,docker and git on master node
    
                  Yum install java-11-openjdk -y



2. Install jenkins on master node
                 
               sudo wget -O /etc/yum.repos.d/jenkins.repo    https://pkg.jenkins.io/redhat-stable/jenkins.repo

      sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

      yum install jenkins
      systemctl enable jenkins
     systemctl start jenkins

       Access URL http://HostIpAddress(public):8080
       We will be asked to enter the password, like below -
      
    When prompted get the password from below location and enter it -
               cat /var/lib/jenkins/secrets/initialAdminPassword
   After installing required plugins and asking for a user creation, you will get a default jenkins dashboard as below.
  
3. Install java,docker and git on slave node.
4. Create a user and ssh keys on slave node.
           useradd jenkins
           In order to execute docker statements without sudo permissions use below commands:
             Usermod -aG docker jenkins
             Reboot the instance in-order to apply docker permissions.
5. Generate keys on master node and Copy public key to slave node.
      On master :- 
         First change to jenkins user →su - jenkins -s /bin/bash
         As jenkins is a service account there wouldn’t be access to /bin/bash so issue above command to change the user and generate keys.
       Key generation →ssh-keygen -t rsa
      cd .ssh/
     cat id_rsa.pub  → copy this o/p
     On Slave:- 
     Change to jenkins user → su - jenkins
     Change directory → cd .ssh 
    Create a authorized file → authorized_keys
    Copy the public key to authorized_keys file.




6. Join slave node to master
   First make the master node as non-executable by removing the build executors on it.
  Manage Jenkins →Nodes →master node→configure
Change “No of executors” as Zero.
    
Follow below path in image and add ‘Private Key’ of master as credentials in jenkins.

Select Build Executor Status > New Node > Type - Permanent 
Select below values -
Name - jenkins-slave1
Description - jenkins-slave1
Number of executors - 2
Remote root directory - /home/jenkins/jenkins_node
Labels - python
Usage - Use this mode as much as possible
Launch method - Launch agents via SSH

Host - 172.31.47.100 (Slave worker IP)
Credentials - Use the credentials which we have updated on jenkins
Host Key Verification Strategy - Know hosts key strategy
Save and check that new slave node is added and is in sync

7. Test Jenkins Jobs -
     Before configuring the jenkins job, we will add a hook to github repository which we will be using when building job.

Payload URL → http://jenkinsHostIP:Port/github-webhook/
Events → Based on git events you can trigger the build.
Configure Jenkins Job:-
Create "new item"
Enter an item name – Python App
Chose Pipeline project
In build triggers choose “Git scm polling” → Any change in git repository will build the job automatically.



Mention the github repo link, as my repo is a public one it doesn’t require credentials.

Mention the correct branch which you watch for changes,so that it could trigger the build.

There would be a ‘jenkinsfile’ on git repo where we maintain the steps for a build job.























                   





















