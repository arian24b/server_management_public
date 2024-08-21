#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Author: ArianOmrani - https://github.com/arian24b/

from requests import request, Response
from socket import gethostbyname, gethostname
from os import listdir, path, remove, walk
from tempfile import mkdtemp
from datetime import datetime
from shutil import rmtree
from subprocess import Popen, DEVNULL, run
from typing import Tuple
from zipfile import ZipFile
from time import sleep


# Declare Paths & Settings
HOSTNAME = gethostname()
IP = request(method="get", url="https://api.ipify.org").text if gethostbyname(HOSTNAME) in "127.0.0.1" else gethostbyname(HOSTNAME)
DIR_PATH = "/home"
TELEGRAM_BOT_TOKEN = ""
TELEGRAM_CHAT_ID = ""
TELEGRAM_API_ID = ""
TELEGRAM_API_HASH = ""
TELEGRAM_LOCAL_API_PORT = "5687"
TELEGRAM_LOCAL_API_URL = f"http://127.0.0.1:{TELEGRAM_LOCAL_API_PORT}"
TELEGRAM_BOT_API_BINARY_NAME = "telegram-bot-api"
TELEGRAM_BOT_API_BINARY_PATH = f"/home/arian/backup/{TELEGRAM_BOT_API_BINARY_NAME}"


def run_telegram_bot_api() -> Tuple[Popen, str]:
    """
    Runs the Telegram Bot API binary with the specified arguments.

    Returns:
        Tuple[Popen, str]: A tuple containing the Popen object representing the running process and the temporary directory path.

    Raises:
        None
    """
    # Create a temporary directory
    tmp_dir = mkdtemp(prefix=f"{TELEGRAM_BOT_API_BINARY_NAME}-")

    # Kill all instances of the telegram-bot-api binary
    kill_args = [
        "killall",
        "-9",
        TELEGRAM_BOT_API_BINARY_NAME
    ]
    run(args=kill_args, stdout=DEVNULL, stderr=DEVNULL)

    # Arguments to pass to the telegram-bot-api binary
    run_args = [
        TELEGRAM_BOT_API_BINARY_PATH,
        f"--api-id={TELEGRAM_API_ID}",
        f"--api-hash={TELEGRAM_API_HASH}",
        f"--http-port={TELEGRAM_LOCAL_API_PORT}",
        f"--dir={tmp_dir}",
        f"--temp-dir={tmp_dir}",
        "--local"
    ]

    # Execute the telegram-bot-api binary with the specified arguments
    try:
        bot_api_process = Popen(args=run_args, stdout=DEVNULL, stderr=DEVNULL)
        sleep(0.5)
    except Exception as e:
        # print(f"An error occurred: {e}")
        rmtree(tmp_dir)  # Clean up if error occurs
        raise

    return bot_api_process, tmp_dir


def telegram_send_message(message: str, chat_id: str = TELEGRAM_CHAT_ID) -> Response:
    """
    Sends a message to a Telegram chat using the Telegram Bot API.

    Args:
        message (str): The message to send.
        chat_id (str, optional): The ID of the chat to send the message to. Defaults to TELEGRAM_CHAT_ID.

    Returns:
        Response: The response object from the API call.

    This function constructs the URL for the Telegram Bot API endpoint and sends a POST request to send a message.
    The message is sent to the specified chat using the provided token and chat ID.
    The function returns the response object from the API call.
    """
    response = request(
        method="POST",
        url=f"https://api.telegram.org/bot{TELEGRAM_BOT_TOKEN}/sendMessage",
        data={"chat_id": chat_id, "text": message}
    )

    return response


def telegram_send_file(file_path: str, caption: str, chat_id: str = TELEGRAM_CHAT_ID) -> Response:
    """
    Sends a file to a Telegram chat using the specified file path, caption, and chat ID.

    Args:
        file_path (str): The path to the file to be sent.
        caption (str): The caption to be included with the file.
        chat_id (str, optional): The ID of the chat to send the file to. Defaults to TELEGRAM_CHAT_ID.

    Returns:
        Response: The response object containing the result of the file sending request.
    """
    f = open(file_path, "rb")

    response = request(
        method="POST",
        url=f"{TELEGRAM_LOCAL_API_URL}/bot{TELEGRAM_BOT_TOKEN}/sendDocument",
        data={"chat_id": chat_id, "caption": caption, "parse_mode": "HTML"},
        files={"document": f}
    )

    f.close()

    return response


def retrieve_file_paths(dir_path: str) -> list:
    """
    Retrieves the file paths of all files in the specified directory and its subdirectories.

    Args:
        dir_path (str): The path of the directory to retrieve the file paths from.

    Returns:
        list: A list of file paths of all files in the specified directory and its subdirectories.
    """
    filePaths = []

    # Read all directory, subdirectories and file lists
    for root, _, files in walk(dir_path):
        for filename in files:
            # Create the full filepath by using os module.
            filePaths.append(path.join(root, filename))

    return filePaths


def create_backup(path_to_backup: str, backup_path: str) -> None:
    """
    Creates a backup of the files and folders in the specified directory and saves it as a zip file.

    Args:
        path_to_backup (str): The path to the directory to be backed up.
        backup_path (str): The path where the backup zip file will be saved.

    Returns:
        None: This function does not return anything.

    Raises:
        None: This function does not raise any exceptions.

    Notes:
        - If the backup_path does not end with ".zip", the function will automatically append ".zip" to it.
        - The function uses the retrieve_file_paths function to get a list of all files and folders in the specified directory.
        - The function uses the ZipFile class from the zipfile module to create the zip file.
        - Each file in the filePaths list is written to the zip file using the write method of the ZipFile class.
    """
    backup_path = backup_path if backup_path.endswith(".zip") else backup_path + ".zip"

    # Call the function to retrieve all files and folders of the assigned directory
    filePaths = retrieve_file_paths(path_to_backup)

    # write files and folders to a zipfile
    with ZipFile(backup_path, "w") as zfile:
        # write each file seperately
        for file in filePaths:
            zfile.write(file)


def main() -> None:
    """
    Runs the main backup process, which includes starting the Telegram Bot API in the background, getting the IP address, sending a message that the backup process has started, creating a temporary backup path, looping through each directory in the specified path, defining the backup path, defining the title and caption, creating a zip archive of the specified path, sending the backup file to Telegram, removing the backup file, killing the bot API process, removing the temporary backup path, and sending a message that the backup process has completed.
    """
    # Start time
    start_time = datetime.now().strftime("%Y-%m-%d-%H:%M:%S")

    # Send a message that the backup process has started
    telegram_send_message(message=f"Start creating backup from {DIR_PATH} {start_time}")

    # Run the bot API in the background
    bot_api_process, temp_dir = run_telegram_bot_api()

    # Create a temporary backup path
    tmp_backup_path = mkdtemp(prefix="backup-")

    # Loop through each directory in the specified path
    for homedir in listdir(DIR_PATH):
        path_to_backup = path.join(DIR_PATH, homedir)
        if path.isdir(path_to_backup):
            # Define the backup path
            backup_path = path.join(tmp_backup_path, f"{homedir}-backup-{start_time}.zip")
            # Define the title and caption
            title = f"Backup: {path_to_backup}"
            caption = f"{title}\n<code>{start_time}</code>\n<code>{HOSTNAME}: {IP}</code>"

            # Create a zip archive of the specified path
            create_backup(path_to_backup, backup_path)

            # Send the backup file to Telegram
            telegram_send_file(file_path=backup_path, caption=caption)

            # Remove the backup file
            remove(backup_path)

    # End time
    end_time = datetime.now().strftime("%Y-%m-%d-%H:%M:%S")

    # Kill the bot API process
    bot_api_process.kill()

    # Remove the temporary backup path
    rmtree(tmp_backup_path)
    rmtree(temp_dir)

    # Send a message that the backup process has completed
    telegram_send_message(message=f"Backup from server {HOSTNAME}: {IP} from path: {DIR_PATH} in {start_time} to {end_time}.")


if __name__ == "__main__":
    main()
