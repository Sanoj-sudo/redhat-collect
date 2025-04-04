#!/bin/bash


# Check if gum is installed
if ! command -v gum &> /dev/null; then
    echo "Error: 'gum' is not installed. Please install gum before running this script."
    exit 1
fi

# Ensure gum and sysstat (mpstat) are installed
if ! command -v mpstat &> /dev/null; then
    sudo apt update && sudo apt install sysstat -y
fi

while true; do
    # Display a selection menu
    CHOICE=$(gum choose "CPU Utilization" "Memory Utilization" "Disk Utilization" "Network Utilization" "Exit")

    case $CHOICE in 
        "CPU Utilization")
            #CPU_USAGE=$(mpstat 1 1 | awk '/all/ {print 100 - $NF "%"}')
            CPU_USAGE=$(mpstat 1 1 | awk '/all/ {print 100 - $NF "%"}' | head -n 1)
            gum style --border "rounded" --foreground 255 --background 27 --border-foreground 27 --align center --width 50 --margin "1 2" --padding "2 4" "CPU Usage: $CPU_USAGE"
            ;;
        "Memory Utilization")
            MEM_USAGE=$(free -m | awk '/Mem:/ {print $3 "MB / " $2 "MB (" $3*100/$2 "%)"}')
            gum style --border "rounded" --foreground 255 --background 28 --border-foreground 28 --align center --width 50 --margin "1 2" --padding "2 4" "Memory Usage: $MEM_USAGE"
            ;;
        "Disk Utilization")
            DISK_USAGE=$(df -h | awk '$NF=="/" {print $3 " / " $2 " (" $5 ")"}')
            gum style --border "rounded" --foreground 255 --background 124 --border-foreground 124 --align center --width 50 --margin "1 2" --padding "2 4" "Disk Usage: $DISK_USAGE"
            ;;
        "Network Utilization")
            INTERFACE=$(ip route | grep default | awk '{print $5}')
            RX1=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
            TX1=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
            sleep 1
            RX2=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
            TX2=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
            DOWNLOAD=$(( (RX2 - RX1) / 1024 ))
            UPLOAD=$(( (TX2 - TX1) / 1024 ))
            gum style --border "rounded" --foreground 255 --background 33 --border-foreground 33 --align center --width 50 --margin "1 2" --padding "2 4" "Download: $DOWNLOAD KB/s | Upload: $UPLOAD KB/s"
            ;;
        "Exit")
            gum style --border "rounded" --foreground 255 --background 160 --border-foreground 160 --align center --width 50 --margin "1 2" --padding "2 4" "Exiting..."
            exit 0
            ;;
        *)
            gum style --border "rounded" --foreground 255 --background 214 --border-foreground 214 --align center --width 50 --margin "1 2" --padding "2 4" "Invalid selection"
            ;;
    esac
done
