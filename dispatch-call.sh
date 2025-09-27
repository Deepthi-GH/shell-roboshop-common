#!/bin/bash

source ./common-code.sh

app_name=dispatch

CHECK_ROOT
APP_SETUP
GOLANG_SETUP
SYSTEMD_SETUP
APP_RESTART
PRINT_TOTAL_TIME