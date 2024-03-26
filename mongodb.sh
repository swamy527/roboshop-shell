#!/bin/bash
Timestamp=$(date +%F)
Logs="/tmp/$0-$Timestamp.log"
Id=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
       echo -e $2 is $R Failed $N 
    else
       echo -e $2 is $G success $N 
    fi
}

echo "code start executing"

if [ $Id -ne 0 ]
then
    echo -e $R Run code with root privileges $N
    exit 1
else
    echo -e $G you are root user $N
fi

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $Logs

VALIDATE $? "copying files"

dnf install mongodb-org -y &>> $Logs

VALIDATE $? "installling mongodb"

systemctl enable mongod &>> $Logs

VALIDATE $? "enable mongodb"

systemctl start mongod &>> $Logs

VALIDATE $? "start mongodb"

sed -i 's/127.0.0.0/0.0.0.0/g' /etc/mongod.conf &>> $Logs

VALIDATE $? "updating mongd.conf"

systemctl restart mongod &>> $Logs

VALIDATE $? "restarting mongod"