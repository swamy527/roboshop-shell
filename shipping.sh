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

dnf install maven -y &>>$Logs

VALIDATE $? "installing maven"

useradd roboshop &>>$Logs

VALIDATE $? "useradd"

mkdir /app &>>$Logs

VALIDATE $? "new directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$Logs

VALIDATE $? "application download"

cd /app &>>$Logs
VALIDATE $? "change directory"

unzip /tmp/shipping.zip &>>$Logs
VALIDATE $? "unzipping application"

mvn clean package &>>$Logs

VALIDATE $? "downloadin dependecies"

mv target/shipping-1.0.jar shipping.jar &>>$Logs
VALIDATE $? "renaming jarfile"

cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system &>>$Logs
VALIDATE $? "copy service file to systemd"

systemctl daemon-reload &>>$Logs
VALIDATE $? "daemon reload"

systemctl enable shipping &>>$Logs
VALIDATE $? "enabling shipping service"

systemctl start shipping &>>$Logs
VALIDATE $? "starting shipping"

dnf install mysql -y &>>$Logs
VALIDATE $? "install mysql"

mysql -h mysql.beesh.life -uroot -pRoboShop@1 </app/schema/shipping.sql &>>$Logs
VALIDATE $? "loadin schema"

systemctl restart shipping &>>$Logs
VALIDATE $? "restarting service"
