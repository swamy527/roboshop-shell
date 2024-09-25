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
dnf module disable nodejs -y  &>> $Logs

VALIDATE $? "nodejs disable"

dnf module enable nodejs:18 -y &>> $Logs

VALIDATE $? "enable nodejs:18"

dnf install nodejs -y &>> $Logs

VALIDATE $? "installing nodejs"

useradd roboshop &>> $Logs



VALIDATE $? "user add"

mkdir /app &>> $Logs

VALIDATE $? "new directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip  &>> $Logs
 
VALIDATE $? "downloading application"

cd /app  &>> $Logs

VALIDATE $? "change directory"

unzip /tmp/catalogue.zip &>> $Logs

VALIDATE $? "unzipping application"

npm install  &>> $Logs

VALIDATE $? "npm installing"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system &>> $Logs

VALIDATE $? "copying file to systemd"

systemctl daemon-reload &>> $Logs

VALIDATE $? "daemon reload"

systemctl enable catalogue &>> $Logs
VALIDATE $? "eablling service"

systemctl start catalogue &>> $Logs
VALIDATE $? "start service"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d &>> $Logs

VALIDATE $? "copying file yum repos"

dnf install mongodb-org-shell -y &>> $Logs

VALIDATE $? "install mongo client"

mongo --host 172.31.80.167 </app/schema/catalogue.js &>> $Logs

VALIDATE $? "copy schme products"

systemctl restart catalogue &>> $Logs

VALIDATE $? "start service"