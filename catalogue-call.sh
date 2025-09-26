#!/bin/bash

source ./common-code.sh
app_name=catalogue

APP_SETUP
NODEJS_SETUP
SYSTEMD_SETUP

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "installing mongodb client"

INDEX=$(mongosh --host $MONGODB_HOST --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 0 ] 
then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "load products data"
else
    echo -e "already $app_name products loaded ...$Y SKIPPING $N"
fi    

APP_RESTART
PRINT_TOTAL_TIME