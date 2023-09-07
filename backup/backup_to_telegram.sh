#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Auther: ArianOmrani - https://github.com/arian24b/
# git repository: https://github.com/arian24b/server_management_public

set -e
# set -x

clear

GIT_REPO=https://github.com/arian24b/server_management_public

# Load Template
source <(curl -SskL $GIT_REPO/raw/main/template.sh)

# Declare Paths & Settings.
DIR_PATH=/home
TMP_BACKUP_PATH=$(mktemp -d)
TELEGRAM_TOKEN="0123456789:AAAAAAAAAAAAAAAAAAAAAAAAAA"
TM_CHATID="409804739"
export IP=$(hostname -I)
export HOSTNAME=$(hostname)

# Send message
function send_message() {
  curl -F chat_id="$TM_CHATID" -F text="$1" "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" >/dev/null 2>&1
}

# Chack TM_CHATID is number
if [[ ! $TM_CHATID =~ ^\-?[0-9]+$ ]]; then
  abort "${TM_CHATID} is not a number.";
fi

START_TIME=$DATE

bash /home/arian/backup/run_bot_api.sh &

send_message "Start creating backup from $DIR_PATH $START_TIME"

for HOMEDIR in $(ls -1 $DIR_PATH); do
  BACKUP_PATH="$TMP_BACKUP_PATH/$HOMEDIR-Backup-$DATE.zip"
  PATHS="$DIR_PATH/$HOMEDIR"
  TITEL="Backup from: $PATHS"
  CAPTION="$TITEL
  <code>$DATE</code>
  <code>$IP</code>"

  zip -r -q -T -y -9 $BACKUP_PATH $PATHS >/dev/null 2>&1

  curl -F chat_id="$TM_CHATID" -F caption="$CAPTION" -F parse_mode="HTML" -F document=@"$BACKUP_PATH" "http://127.0.0.1:5687/bot${TELEGRAM_TOKEN}/sendDocument" >/dev/null 2>&1 # https://api.telegram.org/bot

done

rm -rf $TMP_BACKUP_PATH

END_TIME=$DATE

send_message "Backup from server $HOSTNAME: $IP from path: $DIR_PATH in $START_TIME to $END_TIME."
