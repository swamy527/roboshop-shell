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

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$Logs

VALIDATE $? "installing rpm package"

dnf module enable redis:remi-6.2 -y &>>$Logs

VALIDATE $? "enablin redis"

dnf install redis -y &>>$Logs

VALIDATE $? "installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>>$Logs
VALIDATE $? "replacing redis string"

systemctl enable redis &>>$Logs
VALIDATE $? "enablin redis"

systemctl start redis &>>$Logs
VALIDATE $? "starting redis"
