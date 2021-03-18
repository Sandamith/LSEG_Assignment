#!/bin/bash

#This is the first script.
#This script runs inside run-script1.sh

#Purpose of this script :

#Access the public server via ssh.
#Check if web-server is running and start if it is not.
#Check if web-server serving expected content.

#Author - Sachinthya Sandamith Wanigasuriya

#######################################################

#Public DNS of ec2-instance.

dns=ec2-13-229-146-238.ap-southeast-1.compute.amazonaws.com

#Connect to ec2-instance via ssh.

sudo ssh -i test-key.pem ec2-user@$dns<<EOF 

echo "Login_success"

#Checking if web-server is running and start it if is not.

if [ "`sudo systemctl is-active httpd`" = "inactive" ]; then
	sudo systemctl start httpd && echo "Apache_launch_success" 2>>data/errors.txt 
	sleep 3
fi

#Checking if web-server is serving expected content with the http status code 200

if [ `curl -o -I -L -s -w "%{http_code}" $dns` -eq 200 ]; then
	echo "Web_server_content_check_success" 2>>data/errors.txt
fi

EOF


