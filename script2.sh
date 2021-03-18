#!/bin/bash

#This is the second script.
#This script runs inside run-script2.sh

#Purpose of this script :

#Copy content of the web-server.
#Copy Apache web-server log files.
#Create one compressed file.

#Author - Sachinthya Sandamith Wanigasuriya

###########################################

#Public DNS for ec-2 instance

dns=ec2-13-229-146-238.ap-southeast-1.compute.amazonaws.com

#Connect to ec2-instance via ssh.

sudo ssh -i test-key.pem ec2-user@$dns <<EOF

#Copy content of the web-server to a directory created by me within ec2-instance.

sudo cp /var/www/html/index.php /home/ec2-user/data/ && echo "Web-server content copied"


#Copy apache access_log file to my directory.

sudo cp /etc/httpd/logs/access_log /home/ec2-user/data/ && echo "Apache access-log copied"


#Copy apache error_log file to my directory.

sudo cp /etc/httpd/logs/error_log /home/ec2-user/data/ && echo "Apache error-log copied"


#Compress content file and log files into one file. 

zip data/web_server_data.zip data/index.php data/access_log data/error_log && echo "Compressed data file created"

EOF
