#!/usr/bin/env bash
# -*- coding: utf-8 -*-
# Auther: ArianOmrani - https://github.com/arian24b/
# git repository: https://github.com/arian24b/server_management_public

# Exit immediately if a command exits with a non-zero status
#set -e
# set -x

# Clear the terminal
#clear

# Define the git repository URL
GIT_REPO=https://github.com/arian24b/server_management_public

# Load the template script
source <(curl -SskL $GIT_REPO/raw/main/template.sh)

# Declare Paths & Settings.
# Directory path
DIR_PATH=/home
# Temporary backup path
TMP_BACKUP_PATH=$(mktemp -d)
# Telegram bot token
TELEGRAM_TOKEN="0123456789:AAAAAAAAAAAAAAAAAAAAAAAAAA"
# Telegram chat ID
TM_CHATID="123456789"
# Export the hostname IP
export IP=$(hostname -I)
# Export the hostname
export HOSTNAME=$(hostname)

# Send message function
# Params:
#   $1 - The message to send
function send_message() {
    curl -F chat_id="$TM_CHATID" -F text="$1" "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" >/dev/null 2>&1
}

# Check if TM_CHATID is a number
if [[ ! $TM_CHATID =~ ^\-?[0-9]+$ ]]; then
    abort "${TM_CHATID} is not a number.";
fi

# Start time
START_TIME=$DATE

# Run the bot API in the background
bash /home/arian/backup/run_bot_api.sh &
BOTAPIPID=$!

# Send a message that the backup process has started
send_message "Start creating backup from $DIR_PATH $START_TIME"

# Loop through each directory in the specified path
for HOMEDIR in $(ls -1 $DIR_PATH); do
    # Define the backup path
    BACKUP_PATH="$TMP_BACKUP_PATH/$HOMEDIR-Backup-$DATE.zip"
    # Define the path to backup
    PATHS="$DIR_PATH/$HOMEDIR"
    # Define the title
    TITEL="Backup from: $PATHS"
    # Define the caption
    CAPTION="$TITEL
    <code>$DATE</code>
    <code>$IP</code>"

    # Create a zip archive of the specified path
    zip -r -q -T -y -1 $BACKUP_PATH $PATHS >/dev/null 2>&1

    # Send the backup file to Telegram
    curl -F chat_id="$TM_CHATID" -F caption="$CAPTION" -F parse_mode="HTML" -F document=@"$BACKUP_PATH" "http://127.0.0.1:5687/bot${TELEGRAM_TOKEN}/sendDocument" >/dev/null 2>&1 # https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendDocument

    # Remove the backup file
    rm -f $BACKUP_PATH
done

# Kill the bot API process
kill -9 $BOTAPIPID

# Remove the temporary backup path
rm -rf $TMP_BACKUP_PATH

# End time
END_TIME=$DATE

# Send a message that the backup process has completed
send_message "Backup from server $HOSTNAME: $IP from path: $DIR_PATH in $START_TIME to $END_TIME."
