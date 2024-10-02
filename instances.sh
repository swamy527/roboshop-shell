#!/bin/bash

ID=$(id -u)
Timestamp=$(date +%F-%T)
Logs=/tmp/log.$Timestamp
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
domain="beesh.life"
Host_zone=Z0065515281TOZ02X40CA
instance=("web" "catalogue" "mongodb" "shipping" "user" "cart" "redis" "mysql" "payment" "rabbitmq")

if [ $ID -ne 0 ]; then
    echo -e "\n$R Run script as root user $N \n"
    exit 50
else
    echo -e "\n$G you are root user $N \n"
fi

for i in ${instance[@]}; do
    echo -e "\n launching $i "
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]; then
        INSTANCE_TYPE="t2.medium"
    else
        INSTANCE_TYPE="t2.micro"
    fi
    IP_address=$(aws ec2 run-instances --image-id ami-0b4f379183e5706b9 --count 1 --instance-type $INSTANCE_TYPE --security-group-ids sg-0d86841764a147f28 --tag-specifications "ResourceType=instance, Tags= [{Key=Name, Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)

    echo -e "\n Ipaddress of $i : $IP_address"

    aws route53 change-resource-record-sets --hosted-zone-id $Host_zone --change-batch '		
  {		
    "Comment": "Testing creating a record set"		
    ,"Changes": [{		
    "Action"              : "UPSERT"		
    ,"ResourceRecordSet"  : {		
        "Name"              : "'$i'.'$domain'"		
        ,"Type"             : "A"		
        ,"TTL"              : 1		
        ,"ResourceRecords"  : [{		
            "Value"         : "'$IP_address'"		
        }]		
      }		
    }]		
  }		
   '
done
