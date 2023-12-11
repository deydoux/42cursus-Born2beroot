#!/bin/bash

arch=$(uname -a)
cpu=$(grep -c "^physical id" /proc/cpuinfo)
vcpu=$(grep -c "^processor" /proc/cpuinfo)
memory_usage=$(free -h | grep "^Mem:" | awk '{print $3 "/" $2}')
memory_usage_percent=$(free -b | grep "^Mem:" | awk '{printf "%.2f", $3 / $2 * 100}')
disk_usage=$(df -h --total  | grep "^total" | awk '{print $3 "/" $2 " (" $5 ")"}')
cpu_load=$(vmstat | tail -1 | awk '{print 100 - $15 "%"}')
last_boot=$(uptime -s)

if [ -n "$(lvdisplay)" ]; then
	lvm=yes
else
	lvm=no
fi

connections=$(ss -s | grep "^TCP:" | awk '{printf "%d", $4}')
users=$(users | wc -w)
ip=$(hostname -I)
mac=$(cat /sys/class/net/enp0s3/address)
sudo_commands=$(ls /var/log/sudo/**/** | wc -l)

wall "	#Architecture: $arch
	#CPU physical: $cpu
	#vCPU: $vcpu
	#Memory Usage: $memory_usage ($memory_usage_percent%)
	#Disk Usage: $disk_usage
	#CPU load: $cpu_load
	#Last boot: $last_boot
	#LVM use: $lvm
	#Connections TCP: $connections established
	#User log: $users
	#Network: IP $ip($mac)
	#Sudo: $sudo_commands commands"
