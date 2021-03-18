#!/bin/bash

#This is the main script-2

#Purpose of this script :

#Run the second script. 
#Fetch the second script output; compressed web-server data file to the script location.
#Upload the data file to AWS s3 bucket.
#Send mail to the application-support team if any error occured.

#Author - Sachinthya Sandamith Wanigasuriya

########################################################################################

#Execution errors will be redirected to /script_errors/localerrors_2.txt

>script_errors/localerrors_2.txt

#Run the second script. 

./script2.sh 2>script_errors/localerrors_2.txt

#Fetch the compressed web-server data file from ec2-instance to the script location via scp.

sudo scp -i test-key.pem ec2-user@ec2-13-229-146-238.ap-southeast-1.compute.amazonaws.com:/home/ec2-user/data/web_server_data.zip server_data/ && echo "File downloaded to local machine"  2>>script_errors/localerrors_2.txt 

#Upload the fetched file to aws s3 bucket.

aws s3 cp server_data/web_server_data.zip s3://sandamith-bucket-01 && uploadsuccess=true && echo "Data file uploaded to cloud"

#Deleting file upon upload success.

if [ $uploadsuccess = true ]; then
	sudo rm server_data/web_server_data.zip && echo "Local file deleted"
	echo "********** Success **********"
fi

#Sending mail to app-support team upon upload failure. 

if [ $uploadsuccess != true ]; then
	php email/error2_send_mail.php && echo "Upload Failed" >>localerrors_2.txt
fi
	

