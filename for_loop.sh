#!/bin/bash

instance=("mongodb" "redis" "rabbitmq" "mysql" "user" "cart" "catalogue" "shipping" "payment" "web")

for i in "${instance[@]}"
do
ansible-playbook -e component="$i" main.yaml
done