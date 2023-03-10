#! /bin/bash
set -e

# Ouput all log
exec > >(tee /var/log/user-data.log | logger -t user-data-extra -s 2> /dev/console) 2>&1

# Configure Cloudwatch agent
wget 'https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb'
dpkg -i amazon-cloudwatch-agent.deb

# Use cloudwatch config from SSM
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c ssm:${ssm_cloudwatch_config} -s

echo 'Done initialization'
