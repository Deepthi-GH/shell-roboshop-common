#!/bin/bash
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
B="\e[34m"
N="\e[0m"
LOGS_FOLDER=/var/log/shell-roboshop
SCRIPT_NAME=$( echo $0|cut -d "." -f1 )
LOG_FILE=$LOGS_FOLDER/$SCRIPT_NAME.log
MONGODB_HOST=mongodb.deepthi.cloud
SCRIPT_DIR=$(pwd)
START_TIME=$(date +%s)
mkdir -p $LOGS_FOLDER
echo "script started at: $(date)" |tee -a $LOG_FILE

CHECK_ROOT()
{
if [ $USERID -ne 0 ] 
    then
    echo "error::please run this script with root priviliges"
    exit 1
fi
}
VALIDATE()
{
if [ $1 -ne 0 ] 
    then
    echo -e "error::$2 ...  $R FAILED $N"|tee -a $LOG_FILE
    exit 1
else
    echo -e "$2 ... $Y SUCCESS $N"|tee -a $LOG_FILE
fi    
}

NODEJS_SETUP()  
{
    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? "disabling nodejs"

    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "enabling nodejs"

    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? "installing nodejs"

    cd /app
    npm install
    VALIDATE $? "installing dependencies"
    
}

MAVEN_SETUP()
{   
    dnf install maven -y &>>$LOG_FILE
    VALIDATE $? "installing maven"
    cd /app 
    mvn clean package &>>$LOG_FILE
    VALIDATE $? "clean package"
 
    mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
    VALIDATE $? "moving jar file"
 
}

PYTHON_SETUP()
{
    dnf install python3 gcc python3-devel -y &>>$LOG_FILE
    VALIDATE $? "installing python"
    cd /app 
    pip3 install -r requirements.txt
}

GOLANG_SETUP()  
{
    dnf install golang -y &>>$LOG_FILE
    VALIDATE $? "installing go-lang"
    cd /app 
    go mod init dispatch &>>$LOG_FILE
    VALIDATE $? "initializing dispatch"
    go get  &>>$LOG_FILE
    VALIDATE $? "go get"
    go build &>>$LOG_FILE
    VALIDATE $? "cgo build"
}

APP_SETUP()
{
   id roboshop &>>$LOG_FILE
   if [ $? -ne 0 ]
     then 
     useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$LOG_FILE
     VALIDATE $? "creating user roboshop"
   else
     echo -e "user already existing...$Y SKIPPING $N"    
   fi

   mkdir -p /app  &>>$LOG_FILE
   VALIDATE $? "created /app directory"

   curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
   VALIDATE $? "downloading $app_name application"

    cd /app 
    VALIDATE $? "changing to app directory"
    rm -rf /app/*
    VALIDATE $? "removing existing code"

    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "unzipping the code"

}  
SYSTEMD_SETUP()
{   
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service &>>$LOG_FILE
    VALIDATE $? "copy systemctl file"
    systemctl daemon-reload
    systemctl enable $app_name 
    systemctl start $app_name
}

APP_RESTART()
{
    systemctl restart $app_name 
    VALIDATE $? "restarted $app_name"
}

PRINT_TOTAL_TIME()
{
    END_TIME=$(date +%s)
    TOTAL_TIME=$(($END_TIME - $START_TIME))
    echo -e "script executed at : $Y $TOTAL_TIME seconds"
}