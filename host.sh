#!/bin/bash

ZONE=Z0065515281TOZ02X40CA

aws route53 change-resource-record-sets --hosted-zone-id $ZONE --change-batch '		
  {		
    "Comment": "Testing creating a record set"		
    ,"Changes": [{		
     "Action"              : "CREATE"		
    ,"ResourceRecordSet"  : {		
        "Name"              : "'web'.'beesh.life'"		
        ,"Type"             : "A"		
        ,"TTL"              : 1		
        ,"ResourceRecords"  : [{		
            "Value"         : "'18.206.147.57'"		
        }]		
      }		
    }]		
  }		
   '
