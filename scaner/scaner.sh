#!/bin/bash

# clean work file

rm output-resolved.txt || touch output-resolved.txt
rm output-unavailable.txt || touch output-unavailable.txt

# Declare an array
declare -a lines

# Read the file into the array
mapfile -t lines < hosts.txt

for host in "${lines[@]}"; do
    echo "Host: $host"
    ips=$(dig +short ${host})

    for ip in "${ips[@]}"; do
      # echo "ip: $ip"
      scan_result=$(nmap -p 443 ${ip} | grep open)
      # Capture the exit status
      if [ -n "$scan_result" ]; then
          echo "host=$host ip=$ip status=resolved" >> ./output-resolved.txt
      else
          echo "host=$host ip=$ip status=unavailable" >> ./output-unavailable.txt
      fi
      
    done
done