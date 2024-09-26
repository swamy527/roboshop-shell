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

dnf module disable mysql -y &>>$Logs

VALIDATE $? "disable mysql"

cp /home/centos/roboshop-shell/mysql.repo /etc/yum.repos.d &>>$Logs

VALIDATE $? "copying mysql-repo file"

dnf install mysql-community-server -y &>>$Logs

VALIDATE $? "installing mysql"

systemctl enable mysqld &>>$Logs

VALIDATE $? "enabling mysql"

systemctl start mysqld &>>$Logs

VALIDATE $? "starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$Logs

VALIDATE $? "assigning password for mysql"
