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


dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "MYSQL Installation"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling Mysql server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting Mysql server"

systemctl status mysqld &>>$LOGFILE
VALIDATE $? "Startus of Mysql server"

# If u run this command second time it will fail, bcz already password set
# Error - Password already set, You cannot reset the password with mysql_secure_installation

#mysql_secure_installation --set-root-pass ExpenseApp@1  &>>$LOGFILE 
#VALIDATE $? "Setting up root pwd for Mysql server"

# below one is to check pwd already setup or not. If not then setup.
mysql -h mysql.projexpenses78.online -uroot -pExpenseApp@1 -e 'show databases;'

if [ $? -ne 0 ]
    then    
        mysql_secure_installation --set-root-pass &PASS  &>>$LOGFILE 
        VALIDATE $? "Setting up root pwd for Mysql server"
       
    else 
        echo -e " $Y Password already setup...$N" 
fi 





