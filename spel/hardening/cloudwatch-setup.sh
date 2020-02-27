#!/bin/sh

curl https://s3.amazonaws.com//aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -O

python awslogs-agent-setup.py --region=ap-southeast-2 -n --configfile=/tmp/cloudwatch-audit-logging.conf

# patch the logger python code for FIPS compliance
sed -i 's/hashlib\.md5/hashlib\.sha256/g' /var/awslogs/lib/python2.7/site-packages/cwlogs/push.p

systemctl restart awslogs