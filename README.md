# Installation instructions for RHEL-7.7 SOE

## Overview

This process bootstraps a new STIG Partitioned Enterprise Linux SOE AMI in AWS. It requires the operator to configure an IAM role, start up a vanilla RHEL 7.7 instance (it's not particularly important which OS or version, it just has to be able to install and run packer), install the Packer tool on it, load this codebase onto it and run a command.

## Instructions
0. Switch into the ap-southeast-2 (Sydney) region
1. Create an IAM user for provisioning:
In AWS Console go to IAM -> Add user, call it soe_ami_builder,
  give it programmatic access but not management console access
-> Click Next: Permissions

Select Create group
call it soe_ami_builder, filter policies to find AmazonEC2FullAccess and enable that one policy.
-> Click Next: Tags
-> Click Next: Review
-> Click create user and download the secret access key. This will be your only chance to download the key.

2. Create an instance of RHEL 7.7 to use as the AMI builder:
In the AWS Console go to EC2 -> Instances -> Launch Instance
In Community AMIs find ami-0f1ef883e90ca71c0 and launch that, it can be a t2.micro, it doesn't need much power. Storage and tags can remain at their default settings, you will need a security group to allow SSH from your IP address, if you don't have one, create one during this step. Use your existing ssh key or create one.

3. Logging on to the instance and starting the build
Once that instance has started, ssh on to it as ec2-user with your chosen ssh key.

Create your aws credentials:
create ~/.aws/credentials with the following contents:
```
[default]
aws_access_key_id = <your soe_ami_builder IAM user key id>
aws_secret_access_key = <your soe_ami_builder IAM user access key>
```

and then chmod 600 that file.


Install some tools:
```yum install -y unzip git```

Extract the contents of this package into the home folder
install packer:
```curl -O https://releases.hashicorp.com/packer/1.5.1/packer_1.5.1_linux_amd64.zip```

cd into spel and run the build:
```
cd spel
../packer build -var 'spel_identifier=BOM-SOE' -var 'spel_version=1.0.0' spel/rhel7.json
```

This should take 15 minutes or so. Once completed successfully the build will output an AMI ID which should be visible in the My AMIs section of AWS EC2.