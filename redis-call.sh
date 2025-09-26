#!/bin/bash

source ./common-code.sh
app_name=redis
CHECK_ROOT

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "disabling redis"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "enabling redis"

dnf install redis -y &>>$LOG_FILE 
VALIDATE $? "installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "allowing remote connections to mongodb"'

APP_RESTART
PRINT_TOTAL_TIME
