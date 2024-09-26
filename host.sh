#!/bin/bash

instance=("web", "cart", "user", "redis")

for i in ${instance[@]}; do

    if [ $i == "web" ] || [ $i == "cart" ] || [ $i == "redis" ]; then
        echo -e "\ncorrectly printed $i"
    else
        echo -e "\n printed for $i"
    fi
done
