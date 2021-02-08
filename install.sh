#! /usr/bin/sh

# source parameters.txt file
. ./parameters.txt
# Find OS type and OS Level

OS=`cat /etc/os-release | grep PRETTY_NAME | awk -F= {'print $2}' | awk -F\" {'print $2}'`

if [ "$OS" = "Red Hat" ] || [ "$OS" = "CentOS" ]
then
   VER=`cat /etc/os-release | grep VERSION_ID | awk -F\" {'print $2}' | awk -F. {'print $1}'`
   SUB=`cat /etc/os-release | grep VERSION_ID | awk -F\" {'print $2}'`
   if [ $VER -lt 8 ]
      then
         echo "System runs on OS = $OS and Version = $SUB";
         yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
         subscription-manager repos --enable "rhel-*-optional-rpms" --enable "rhel-*-extras-rpms"  --enable "rhel-ha-for-rhel-*-server-rpms"
         yum -y upgrade
         yum -y install python36
         yum -y install ansible
#        yum -y install psmisc
         yum -y install nginx
#        pip3 install selinux
         yum -y upgrade
   else
         echo "System runs on OS = $OS and Version = $SUB";
         yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noar
         ARCH=$( /bin/arch );subscription-manager repos --enable "codeready-builder-for-rhel-8-${ARCH}-rpms"
         dnf config-manager --set-enabled powertools
         yum -y upgrade
         yum -y install python36
         yum -y install ansible
#        yum -y install psmisc
         yum -y install nginx
#        pip3 install selinux
         yum -y upgrade
   fi
else
    echo "This OS is not supported. We only supprt REHL/CentoOS versions 7 and 8"
fi


### Continue with ansible role

mkdir -p /etc/ansible
touch /etc/ansible/ansible.cfg
touch /etc/ansible/hosts
echo  "[defaults]" > /etc/ansible/ansible.cfg
echo  "ansible_python_interpreter=/usr/bin/python3.6" >> /etc/ansible/ansible.cfg
echo  hostname > /etc/ansible/hosts

echo "##############################################################"
echo "STARTING Ansible Playbook to configure nginx"
echo "###############################################################"

ansible-playbook install_rev_prox_role.yml --extra-vars "COS_ENDPOINT_URL=$cos_endpoint PASSWORD=$password ENCRYPT=$encrypt RSA=$rsa"
