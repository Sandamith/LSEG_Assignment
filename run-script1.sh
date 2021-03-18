#!/bin/bash

#This is the main script-1

#Purpose of this script : 

#Run the first script & record its results and errors. 
#Upload the results of first script to AWS DynamoDB with timestamps.
#Send mail to application-support team if script detects any errors.

#Author - Sachinthya Sandamith Wanigasuriya

###################################################################

#Results of first script will be saved to a file named "logfile" and execution errors will be redirected to script_errors/localerrors_1.txt 

>logfile
>script_errors/localerrors_1.txt

#Run the first scipt while creating the logfile along with timestamps. Epoch timestamp is used here.

./script1.sh | while IFS= read -r line; do printf '%s%s\n' "$(date +%s)" "-$line"; done >>logfile 2>script_errors/localerrors_1.txt && echo "Web server is running and serving content properly"


#Read logfile line by line while uploading them into DynamoDB table. 

while IFS= read -r line; do
	
	IFS='-' read -ra ARR <<< "$line"
		
	aws dynamodb put-item --table-name server_logs --item '{"timestamp":{"N":"'${ARR[0]}'"},"log":{"S":"'${ARR[1]}'"}}' --return-consumed-capacity TOTAL 

done < logfile 2>>script_errors/localerrors_1.txt && echo "Log files uploaded to DB successfully"


#Fetch the error file created within ec2-instance by first script. 

sudo scp -i test-key.pem ec2-user@ec2-13-229-146-238.ap-southeast-1.compute.amazonaws.com:/home/ec2-user/data/errors.txt script_errors/ec2errors.txt 2>>script_errors/localerrors_1.txt && echo "Error file in ec-2 copied" 


#Mail to application-support if any error found. Else complete the execution.

if [ -s /script_errors/ec2errors.txt ] 
then
	php /email/error1_send_mail.php 
else
	echo "All is well" 
	echo "********** Success **********"	
fi	


