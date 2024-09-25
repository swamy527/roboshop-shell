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

cp mongo.repo /etc/yum.repos.d  &>> $Logs

VALIDATE $? "copying file to yum repo"

dnf install mongodb-org -y &>> $Logs

VALIDATE $? "installing mongodb"

systemctl enable mongod  &>> $Logs

VALIDATE $? "enabling mongodb"

sed 's/127.0.0.1/0.0.0.0' /etc/mongod.conf &>> $Logs

VALIDATE $? "updating mongod.conf file"

systemctl start mongod 

VALIDATE $? "starting mongodb" &>> $Logs

