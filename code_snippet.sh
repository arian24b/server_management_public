# Stop and remove all Docker containers
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)

# Search for files containing specific text
SEARCH_DIR="/path/to/search/directory"
SEARCH_TEXT="search-text"
grep -rl "${SEARCH_TEXT}" ${SEARCH_DIR}

# Add prefix to all files in a directory
DIRECTORY="/path/to/directory"
PREFIX="new_prefix_"
for FILE in ${DIRECTORY}/*
do
    mv ${FILE} ${DIRECTORY}/${PREFIX}$(basename ${FILE})
done

# Monitor system usage and resource consumption
while true
  do
      clear
      echo "====== System Usage & Resource Consumption ======"
      echo "CPU Usage"
      echo "------------------------------------------------"
      top -b -n1 | head -10
      echo " "
      echo "Free Memory"
      echo "------------------------------------------------"
      free -h
      echo " "
      echo "Disk Usage"
      echo "------------------------------------------------"
      df -h
      sleep 5
  done

# Script to clean up old log files
DIRECTORY="/var/log"
DAYS=14

echo "Deleting log files older than $DAYS days in $DIRECTORY..."
find "$DIRECTORY" -name "*.log" -type f -mtime +$DAYS -exec rm -f {} \;
echo "Log files cleanup completed successfully."

# Show disks with high usage
df -h | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " " $1 " " $6 }' | while read output;
do
usage=$(echo $output | awk '{ print $1}' | cut -d'%' -f1)
partition=$(echo $output | awk '{ print $2 }')
mount_point=$(echo $output | awk '{ print $3 }')
if [ $usage -ge 80 ]; then
    echo "Warning: Disk space usage on $partition ($mount_point) is at ${usage}%"
fi
done

# Available free space on the system
du -hsx /* | sort -rh | head -5

# Finds all configuration files in /etc with server_name directive
find /etc -name '*.conf' -exec grep -H -i 'server_name' {} \;


# Calculates the total CPU usage percentage of all running processes
ps aux | awk '{sum+=$3}; END{print "Total CPU usage:"; print sum}'


# Show top 10 processes sorted by memory usage
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head

# Backup logs older then 7 days
find / -type f -iname '*.log' -mtime +7 -exec cp {} /backup/logs \;

# Scan a range of IP addresses for open ports
for ip in $(seq 1 254); do nmap -p 80,443 192.168.1.$ip -oG - | grep open; done
# Continuous monitoring of network latency
while true; do date; ping -c 5 google.com | grep icmp_seq; sleep 5; done

# Analyze network packets and their contents with tcpdump
tcpdump -i eth0 -w capture.pcap

# Scan a subnet for all live hosts and their open ports using nmap
nmap -sn -p- 192.168.1.0/24

#nmap -sn -p- 192.168.1.0/24
iperf -c IP_Address -p Port_Number -t Time_Duration


