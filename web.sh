#!/bin/bash

ID=$(id -u)
Timestamp=$(date +%F-%T)
Logs=/tmp/log.$Timestamp
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "\n$R $2 is failed $N \n"
        exit 1
    else
        echo -e "\n$G $2 is success $N \n"
    fi
}

if [ $ID -ne 0 ]; then
    echo -e "\n$R Run script as root user $N \n"
    exit 50
else
    echo -e "\n$G you are root user $N \n"
fi

rm -rf /tmp/log.*

dnf install nginx -y &>>$Logs

VALIDATE $? "installing nginx"

systemctl enable nginx &>>$Logs

VALIDATE $? "enabling nginx"

rm -rf /usr/share/nginx/html/* &>>$Logs

VALIDATE $? "deleting files in html"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$Logs

VALIDATE $? "downloading web application"

cd /usr/share/nginx/html &>>$Logs

VALIDATE $? "direcotry"

unzip /tmp/web.zip &>>$Logs

VALIDATE $? "unzipping file"

cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d &>>$Logs

VALIDATE $? "copying file to default.d"

systemctl start nginx &>>$Logs

VALIDATE $? "starting nginx"
