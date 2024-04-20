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

# check whether user exists or not. If not exist add the user. 
# If user exists then it will return 0, if not 1.
id expense 

if [ $? -ne 0 ]
then    
    useradd expense
    VALIDATE $? "Adding expense user"
else    
    echo -e "$Y expense user already exists... $N"
fi

# we have to check whether folder exists or not.. if not then create otherwise skip it
#In linux for folder we have '-p' - It will check folder exists or not. If not it will create otherwise didn't give anything
mkdir -p /app

if [ -e backend.zip ]
then
    echo "$Y backend.zip file already exist...$N"
else
    #Actually no need to check for .zip file bcz we can run this multiple times also, it won't throw any error. But am checking simply
    curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
    VALIDATE $? "Downloading backend code to tmp folder"
fi


