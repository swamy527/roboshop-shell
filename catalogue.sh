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

if [ $id -ne 0 ]
then
    echo -e $R Run code with root privileges $N
    exit 1
else
    echo -e $G you are root user $N
fi

dnf module disable nodejs -y &>> $Logs

VALIDATE $? "nodejs disable"

dnf module enable nodejs:18 -y &>> $Logs

VALIDATE $? "nodejs:18 enable"

dnf install nodejs -y &>> $Logs

VALIDATE $? "installing nodejs"

id roboshop &>> $Logs

if [ $? -ne 0 ]
then
    useradd roboshop
fi

mkdir -p /app

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $Logs

VALIDATE $? "downloading code"

cd /app     

unzip /tmp/catalogue.zip &>> $Logs

VALIDATE $? "unzipping code"

npm install  &>> $Logs

VALIDATE $? "depencies install"

cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>> $Logs

VALIDATE $? "copying files"

systemctl daemon-reload &>> $Logs

VALIDATE $? "daemon-reload"

systemctl enable catalogue &>> $Logs

VALIDATE $? "enable catalogue"

systemctl start catalogue &>> $Logs

VALIDATE $? "start catalogue"

cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>> $Logs

VALIDATE $? "copying repofile"

dnf install mongodb-org-shell -y &>> $Logs

VALIDATE $? "mongdb-client install"

mongo --host mongodb.broril.in </app/schema/catalogue.js &>> $Logs

VALIDATE $? "copying schema"