#! /usr/bin/sh

# source parameters.txt file
. ./parameters.txt

# Find OS type and OS Level
OS=`cat /etc/os-release | grep ^ID= | awk -F\" {'print $2}'`

if [ "$OS" = "rhel" ] || [ "$OS" = "centos" ]
then

    yum -y install python36
    /usr/bin/python3.6 roles/install_rev_proxy/files/awscli-bundle-2/install -i /usr/local/aws -b /usr/local/bin/aws

    ## The following will install your COS HMAC credentials inot aws cli via the aws configure command

    aws configure set aws_access_key_id $aws_access_key_id
    aws configure set aws_secret_access_key $aws_secret_access_key

else

    roles/install_rev_proxy/files/awscli-bundle-2/install -i /usr/local/aws -b /usr/bin/aws

    ## The following will install your COS HMAC credentials inot aws cli via the aws configure command

    aws configure set aws_access_key_id $aws_access_key_id
    aws configure set aws_secret_access_key $aws_secret_access_key 


fi


## The following will install your COS HMAC credentials inot aws cli via the aws configure command

aws configure set aws_access_key_id $aws_access_key_id
aws configure set aws_secret_access_key $aws_secret_access_key

echo
echo
echo "**********************************************************"
echo
echo "AWS CLI is installed and configured. You can now issue an aws command to access the COS bucket"
echo
echo "For Example:"
echo  "aws --no-verify-ssl --endpoint-url https://169.54.61.101 s3 ls"
echo
echo "**********************************************************"
