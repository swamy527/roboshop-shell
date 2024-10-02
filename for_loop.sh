#!/bin/bash

instance=("web" "catalogue" "mongodb" "shipping" "user" "cart" "redis" "mysql" "payment" "rabbitmq")

for i in "${instance[@]}"
do
ansible-playbook -e component="$i" main.yaml
done