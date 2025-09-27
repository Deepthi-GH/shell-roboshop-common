#!/bin/bash

source ./common-code.sh
app_name=payment

CHECK_ROOT
APP_SETUP
PYTHON_SETUP
SYSTEMD_SETUP
APP_RESTART
PRINT_TOTAL_TIME