#!/bin/bash

DATE=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f 1) # removing .sh in file name
LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# pwd u have to enter ExpenseApp@1
echo "Enter Password: "
read -s PASS

USER=$(id -u)

if [ $USER -ne 0 ]
then 
    echo -e " $R Be a root user to install any package... $N"
    exit 1 # manually stop without continue
else 
    echo "Root user"
fi

VALIDATE()
{
    if [ $1 -ne 0 ]
    then    
        echo -e "$2 is $R failed...$N" 
        exit 1
    else 
        echo -e "$2 is $G Success...$N"
    fi
}

dnf install nginx -y  &>>$LOGFILE
VALIDATE $? "Installing Nginx"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enable Nginx"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Start nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "downloaded to tmp folder"

cd /usr/share/nginx/html &>>$LOGFILE

unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "unzip to nginx/html folder"

cp /home/ec2-user/expenses-proj-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOGFILE
VALIDATE $? "Copied expense.conf to nginx folder"

systemctl restart nginx &>>$LOGFILE
VALIDATE $? "Restarting nginx"

systemctl status nginx &>>$LOGFILE
VALIDATE $? "status nginx"



