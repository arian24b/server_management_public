#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Auther: ArianOmrani - https://github.com/arian24b/
# git repository: https://github.com/arian24b/server_management_public

set -e
# set -x

# Load Template
source <(curl -SskL https://github.com/arian24b/server_management_public/raw/main/template.sh)

clear

# Declare Paths & Settings.
DIR_PATH=/home
TMP_BACKUP_PATH=$(mktemp -d)
TELEGRAM_TOKEN=""
TM_CHATID=""
export IP=$(hostname -I)
export HOSTNAME=$(hostname)

# Send message
function send_message() {
  curl -F chat_id="$TM_CHATID" -F text="$1" https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage 2>&1 /dev/null
}

# Chack TM_CHATID is number
if [[ ! $TM_CHATID =~ ^\-?[0-9]+$ ]]; then
  abort "${TM_CHATID} is not a number.";
fi

START_TIME=$DATE

send_message "Start creating backup from $DIR_PATH $START_TIME"

tmux new-session -d -s "telegram_bot_api_starter" "cd /home/arian/backup/;bash start_bot.sh"

for HOMEDIR in $(ls -1 $DIR_PATH); do
  BACKUP_PATH="$TMP_BACKUP_PATH/$HOMEDIR-Backup-$DATE.zip"
  PATHS="$DIR_PATH/$HOMEDIR"
  TITEL="Backup from: $PATHS"
  CAPTION="$TITEL
  <code>$DATE</code>
  <code>$IP</code>"

  echo "$HOMEDIR Backup $DATE" | zip -r1Tluz $BACKUP_PATH $PATHS & 2>&1 /dev/null
  wait

  curl -F chat_id="$TM_CHATID" -F caption="$CAPTION" -F parse_mode="HTML" -F document=@"$BACKUP_PATH" http://127.0.0.1:5687/bot${TELEGRAM_TOKEN}/sendDocument & >/dev/null 2>&1 # https://api.telegram.org/bot
  wait

  rm -f $BACKUP_PATH
done

tmux kill-session -t telegram_bot_api_starter

END_TIME=$DATE

send_message "Backup from server $HOSTNAME: $IP from path: $DIR_PATH in $START_TIME to $END_TIME."
