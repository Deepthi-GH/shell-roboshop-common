#!/bin/bash

source ./common-code.sh
app_name=shipping
MYSQL_HOST=mysql.deepthi.cloud

CHECK_ROOT
APP_SETUP
MAVEN_SETUP
SYSTEMD_SETUP

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "installing maven"

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities'  &>>$LOG_FILE
if [ $? -ne 0 ]
then 
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    VALIDATE $? "loading schema"

    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
    VALIDATE $? "creating app user"

    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
    VALIDATE $? "loading master data"
else 
    echo -e "shipping data is already loaded. $Y SKIPPING $N"
fi

APP_RESTART
PRINT_TOTAL_TIME
