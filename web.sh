#!/bin/bash

ID=$(id -u)
Timestamp=$(date +%F-%T)
Logs=/tmp/log.$Timestamp
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE() {
    if [ $1 -ne 0 ]
    then
        echo -e "\n$R $2 is failed $N \n"
        exit 1
    else
        echo -e "\n$G $2 is success $N \n"
    fi
}

if [ $ID -ne 0 ]
then
   echo -e "\n$R Run script as root user $N \n"
   exit 50
else
   echo -e "\n$G you are root user $N \n"
fi

rm -rf /tmp/log.*

dnf install nginx -y &>> $Logs

systemctl enable nginx

rm -rf /usr/share/nginx/html/*

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip


cd /usr/share/nginx/html

unzip /tmp/web.zip

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d

systemctl start nginx