#!/bin/bash

DATE=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f 1) # removing .sh in file name
LOGFILE=/tmp/$SCRIPT_NAME-$DATE.log

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

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

dnf module list &>>$LOGFILE
VALIDATE $? "Listing all Available modules"

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling Node.js 18 version"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enable Node.js 20 version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Install Node.js 20 version"

