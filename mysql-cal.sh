#!/bin/bash

source ./common-code.sh
CHECK_ROOT

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "installing mysql-server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? "enabling mysql-server"

systemctl start mysqld  &>>$LOG_FILE
VALIDATE $? "starting mysql-server"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE

PRINT_TOTAL_TIME
