#!/usr/bin/env bash

set -e
# Debug
#set -x
#clear

# Declare Paths, logs & Settings
DATE=$(date +'%Y-%m-%d %H:%M:%S')
WGET="wget --timeout=5 --tries=2 --no-check-certificate"
CURL="curl --max-time 5 --silent"


# Red Messages
function Red_msg() {
  tput setaf 1
  echo "[*] ----- $1"
  tput sgr0
}

# Green Messages
function Green_msg() {
  tput setaf 2
  echo "[*] ----- $1"
  tput sgr0
}

# Yellow Messages
function Yellow_msg() {
  tput setaf 3
  echo "[*] ----- $1"
  tput sgr0
}

# Show an Error and Exit
function Abort() {
  Red_msg "Please check log and run scripts with -x for Debug."
  Red_msg "$1"
  exit 2
}

# Detect Distributor
function DetectLinux() {
  if [ ! -x "$(command -v lsb_release)" ]; then
    apt-get install lsb-release -y -f -q > /dev/null
  fi
  LINUX=$(lsb_release -i | awk '{print $3}');
}

# Detect Location
function DetectLocation() {
  country_code=$(curl -SskL ifconfig.io/country_code)
}

# Check if Running as Root or not
function CheckPrivileges() {
  if [ $EUID -ne 0 ]; then
    Abort "This script needs to be run with superuser privileges.";
  fi
}

# Check python vertion
function CheckPythonVertion() {
  PVi=$(python3 -V | awk '{print $2}' | cut -d "." -f 2)
  if [[ $PVi -lt 9 ]]; then
    Abort "python vertion is older then 9";
  fi
}


# Declare Paths, logs & Settings
DetectLinux; # $LINUX
DetectLocation; # $country_code
CheckPrivileges;
