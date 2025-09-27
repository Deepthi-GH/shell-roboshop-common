#!/bin/sh

source ./common-code.sh
app_name=user

CHECK_ROOT

APP_SETUP

NODEJS_SETUP

SYSTEMD_SETUP
APP_RESTART
PRINT_TOTAL_TIME