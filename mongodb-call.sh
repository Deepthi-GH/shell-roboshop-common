#!/bin/bash

source ./common-code.sh

CHECK_ROOT

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "adding mongorepo"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "INSTALLING MONGODB"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "enabling MONGODB"

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "starting MONGODB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "allowing remote connections to mongodb"

systemctl restart mongod &>>$LOG_FILE
VALIDATE $? "restarting MONGODB"

PRINT_TOTAL_TIME