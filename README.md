# Task 10.3HD

This is the code base for my submission for task 10.3HD

## Introduction

In this task, I have deployed flixtube video streaming web application that was worked upon during the trimester onto GCP.
The deployment was done in an automated manner through a Jenkins server using Jenkinsfile posted in this code base.

## Tools required

- GCP account
- Docker
- Terraform
- Github repository containing code
- Gcloud

## GCP resources created

- Google Kubernetes Engine (GKE)
- VPC
- Firewall rule
- Compute Instance
- Container registry

## Steps I performed for the deployment

1. Made changes to make the code base so that web application can be deployed to GCP (GCP specific changes)
2. Setup a VPC - done to separate IP's assigned from default VPC (Good practice)
3. Setup a firewall rule - done to restrict access to gcp compute instance
4. Setup a compute instance (1) - this instance is used for installing jenkins and other tools like terraform (2), docker(3), gcloud(4) to deploy the web application to GCP.
5. Create a Jenkinsfile pipeline and push it to github
6. Create a Jenkins job which reads the jenkinsfile from github and run it

#### All the above steps are covered in detail in the walkthrough video.

#### (1): Since I am not allowed to create an IAM user and add it to service account in the GCP account that I have access to, I had to install gcloud on the jenkins server and authenticate it to give the instance access to deploy onto GCP. Ideally, this should be handled through an IAM user and not like this. 

#### (2): Steps followed to install terraform

**Reference document followed:** https://learn.hashicorp.com/tutorials/terraform/install-cli

**Commands used:**

sudo yum install -y yum-utils

sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

sudo yum -y install terraform

#### (3): Steps followed to install docker

**Reference document followed:** https://docs.docker.com/engine/install/centos/

**Commands used:**

sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine


sudo yum install -y yum-utils


sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo


sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin


sudo systemctl start docker

#### Post docker installation steps

sudo groupadd docker

sudo usermod -aG docker $USER

sudo usermod -a -G docker jenkins

newgrp docker

grep docker /etc/group (verify the users were added)

sudo usermod -s /bin/bash jenkins  (to enable bash for jenkins user)

sudo reboot

#### (4): Steps followed to install docker

**Commands used:**

sudo yum install -y dnf 

sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el8-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM

gcloud init (open the link that is produced by this command and paste the code that is provided)

##### Note: Since in GCP, we don't can't explicitly create a container registry, we don't have docker login details for the registry like we do in Azure cloud platform. The container registry is created directly when we try to push the docker image using the following tag structure: gcr.io/<registry-name>:<version>. To give access to jenkins server to perform this, we have to follow the steps (shown in walkthrough video as well):

1. Visit the service account page and download the admin service account key (json file)
2. Copy the contents and create a file on the jenkins server using those contents,
3. Run gcloud auth activate-service-account <service-acoount-email) –-key-file=<file-created-on-server>
4. gcloud auth configure-docker (Configures docker for that service account on that server after authentication is complete, can pull/push images to gcr now)

Again, this is just a workaround and ideally a service account with appropriate IAM roles should be created, which can be impersonated in the docker login command in video-streaming.tf file as follows:

gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://australia-southeast1-docker.pkg.dev **can be changed to:**

gcloud auth print-access-token --impersonate-service-account <service account with requrired permissions created through terraform> | docker login -u oauth2accesstoken --password-stdin https://australia-southeast1-docker.pkg.dev


Thank you for reading through this, hopefully you are able to deploy the web app using these steps and watching the walkthrough video. :)