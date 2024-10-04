#!/bin/bash

instance=("mongodb" "redis" "rabbitmq" "mysql" "user" "cart" "catalogue" "shipping" "payment" "web")

cd /tmp

git clone https://github.com/swamy527/roboshop-ansible-roles.git

cd /tmp/roboshop-ansible-roles

for i in "${instance[@]}"
do
ansible-playbook -e component="$i" main.yaml
done