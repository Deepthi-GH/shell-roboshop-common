#!/bin/bash
 source ./common-code.sh

CHECK_ROOT

cp $SCRIPT_DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>LOG_FILE
VALIDATE $? "COPYING REPO FILE"

dnf install rabbitmq-server -y &>>LOG_FILE
VALIDATE $? "installing rabbitmq"

systemctl enable rabbitmq-server &>>LOG_FILE
VALIDATE $? "enabling rabbitmq"

systemctl start rabbitmq-server &>>LOG_FILE
VALIDATE $? "starting rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>>LOG_FILE

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>LOG_FILE
VALIDATE $? "setting up permissions"

PRINT_TOTAL_TIME