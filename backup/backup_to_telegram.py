#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Author: ArianOmrani - https://github.com/arian24b/

from requests import request, Response
from socket import gethostbyname, gethostname
from os import listdir, path, remove
from tempfile import mkdtemp
from datetime import datetime
from shutil import make_archive, rmtree
from subprocess import Popen


# Declare Paths & Settings
DIR_PATH = '/home'
TMP_BACKUP_PATH = mkdtemp(prefix="backup_")
TELEGRAM_TOKEN = "0123456789:AAAAAAAAAAAAAAAAAAAAAAAAAA"
TM_CHATID = "123456789"
HOSTNAME = gethostname()

# Start time
START_TIME = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

# Run the bot API in the background
bot_api_script = '/home/arian/backup/run_bot_api.sh'
bot_api_process = Popen(['bash', bot_api_script])


def get_ip(domain: str = HOSTNAME) -> str:
    ip = gethostbyname(domain)
    if ip in "127.0.0.1":
        ip = request(method="get", url="https://api.ipify.org", allow_redirects=True, timeout=60, verify=False).text

    return ip


IP = get_ip()


def send_message(message: str, token: str = TELEGRAM_TOKEN, chat_id: str = TM_CHATID) -> Response:
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    payload = {'chat_id': chat_id, 'text': message}
    response = request(method=f"POST", url=url, data=payload, allow_redirects=True, timeout=60, verify=False)

    return response


def send_file(file_path: str, caption: str, token: str = TELEGRAM_TOKEN, chat_id: str = TM_CHATID) -> Response:
    with open(file_path, 'rb') as file:
        url = f"http://127.0.0.1:5687/bot{token}/sendDocument"
        files = {'document': file}
        data = {'chat_id': chat_id, 'caption': caption, 'parse_mode': 'HTML'}
        response = request(method="POST", url=url, files=files, data=data, allow_redirects=True, timeout=60, verify=False)

    return response


# Send a message that the backup process has started
send_message(message=f"Start creating backup from {DIR_PATH} {START_TIME}")

# Loop through each directory in the specified path
for homedir in listdir(DIR_PATH):
    path_to_backup = path.join(DIR_PATH, homedir)
    if path.isdir(path_to_backup):
        # Define the backup path
        backup_path = path.join(TMP_BACKUP_PATH, f"{homedir}-Backup-{START_TIME}.zip")
        # Define the title and caption
        title = f"Backup from: {path_to_backup}"
        caption = f"{title}\n<code>{START_TIME}</code>\n<code>{IP}</code>"

        # Create a zip archive of the specified path
        make_archive(base_dir=backup_path.replace('.zip', ''), format='zip', root_dir=path_to_backup)

        # Send the backup file to Telegram
        send_file(file_path=backup_path, caption=caption)

        # Remove the backup file
        remove(backup_path)

# Kill the bot API process
bot_api_process.kill()

# Remove the temporary backup path
rmtree(TMP_BACKUP_PATH)

# End time
END_TIME = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

# Send a message that the backup process has completed
send_message(message=f"Backup from server {HOSTNAME}: {IP} from path: {DIR_PATH} in {START_TIME} to {END_TIME}.")
