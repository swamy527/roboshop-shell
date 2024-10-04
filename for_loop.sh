#!/bin/bash

instance=("mongodb" "redis" "rabbitmq" "mysql" "user" "cart" "catalogue" "shipping" "payment" "web")

echo -e "\n installing ansible "

yum install ansible -y

cd /tmp

git clone https://github.com/swamy527/roboshop-ansible-roles.git

cd /tmp/roboshop-ansible-roles

for i in "${instance[@]}"
do
ansible-playbook -e component="$i" main.yaml
done