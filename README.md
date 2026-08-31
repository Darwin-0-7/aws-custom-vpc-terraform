AWS Custom VPC & EC2 Provisioning with Terraform
📌 Project Overview
This project demonstrates Infrastructure as Code (IaC) principles by automating the creation of a highly available and secure custom Virtual Private Cloud (VPC) on Amazon Web Services (AWS) using Terraform.
It provisions a complete network infrastructure from scratch, including subnets, routing, and security groups, and ultimately deploys an Ubuntu EC2 instance configured as an Apache Web Server using automated shell scripts (user_data).
🏗️ Architecture & Components
The following AWS resources are provisioned automatically:
Custom VPC: A dedicated isolated network (10.0.0.0/16).
Public & Private Subnets: Segregated network architecture across availability zones (ap-south-1a, ap-south-1b).
Internet Gateway (IGW): Attached to the VPC to enable internet access for the public subnet.
Route Tables: Configured to direct internet-bound traffic from the public subnet to the IGW.
Security Groups: Acting as a virtual firewall allowing inbound HTTP (Port 80) and SSH (Port 22) traffic.
EC2 Instance (Web Server): An Ubuntu 22.04 server deployed in the public subnet.
Bootstrapping: Automated installation and configuration of the Apache Web Server upon instance launch.
🛠️ Prerequisites
Before running this project, ensure you have the following installed and configured:
Terraform (v1.0.0+)
AWS CLI configured with valid IAM User credentials.
An active AWS Account.
🚀 How to Execute the Code
Clone the repository git clone https://github.com/Darwin-0-7/aws-custom-vpc-terraform.git cd aws-custom-vpc-terraform
Initialize Terraform (Downloads the necessary AWS provider plugins) terraform init
Preview the execution plan (Verifies the resources that will be created) terraform plan
Deploy the infrastructure (Type 'yes' when prompted) terraform apply
Access the Web Server Once the apply is complete, Terraform will output the public IP address of the EC2 instance. Copy the IP and open it in your browser: http://<web_server_public_ip>
🧹 Cleanup
To avoid incurring unnecessary AWS charges, destroy the infrastructure once testing is complete: terraform destroy
💡 Tech Stack Used
Cloud Provider: Amazon Web Services (AWS)
Infrastructure as Code: Terraform
OS & Scripting: Linux (Ubuntu), Bash Shell Scripting
