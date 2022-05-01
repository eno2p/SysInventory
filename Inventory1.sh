#!/bin/bash
#
#

unset InfoInventory
unset TargetDirectory

apt-get install wput -y

FtpServer="TO BE DEFINED"
TargetDirectory="/root/"$HOSTNAME"/"
InfoInventory=$HOSTNAME"_inventory.txt"


declare -a InforArray
declare -a HeadArray

HeadArray[0]="#;"
HeadArray[1]="Date;"
HeadArray[2]="Hostname;"
HeadArray[3]="Kernel;"
HeadArray[4]="System OS;"
HeadArray[5]="Last Boot;"
HeadArray[6]="Up Time;"
HeadArray[7]="CPU;"
HeadArray[8]="Memory;"
HeadArray[9]="Disk(s);"
HeadArray[10]="/Home size;"
HeadArray[11]="IP Address;"
HeadArray[12]="Mac Address;"
HeadArray[13]="Update(s);"
HeadArray[14]="Manufactory"


InforArray[0]=1";"
InforArray[1]=$(date)";"
InforArray[2]=$HOSTNAME";"
InforArray[3]=$(uname -r -p)";"
InforArray[4]=$(cat /etc/*-release | grep -i pretty_name | cut -d '=' -f2 | tr -d '"' )";"
InforArray[5]=$(uptime -s)";"
InforArray[6]=$(uptime -p)";"
InforArray[7]=$(cat /proc/cpuinfo |grep -i 'model name' | wc -l)" core of"\
$(cat /proc/cpuinfo |grep -i 'model name' | cut -d ':' -f2 | uniq)";"
InforArray[8]=$(free -h | grep -i Mem |tr -s '\t' ' ' | cut -d ' ' -f2)";"
InforArray[9]=$(df -Th | grep -i /dev/sda | tr -s '\t' ' ')";"
InforArray[10]=$(du -h -s -c /home/* |grep -i total | tr -s '\t' ' ' | cut -d ' ' -f1)";"
InforArray[11]=$(ip a | cut -d ":" -f2 | grep inet | tr -s '\t' ' ' | cut -d ' ' -f3,10 | tr -s '\n' ' ' | \
cut -d ' ' -f2-)";"
InforArray[12]=$(ip a | grep link/ether | tr -s '\t' ' ' | cut -d ' ' -f3 | tr -s '\n' ' ')";"
InforArray[13]=$(apt update -y 2> /dev/null | grep -i 'can be upgraded' | tr -s '\t' ' ' | cut -d " " -f1)";"
InforArray[14]=$(lshw 2> /dev/null | grep product | head -n 1 | tr -s " " " " | cut -d ":" -f2)


if [ ! -s $TargetDirectory$InfoInventory ]
then

    mkdir $TargetDirectory
    echo ${HeadArray[*]} > $TargetDirectory$InfoInventory

fi

echo ${InforArray[*]} >> $TargetDirectory$InfoInventory

chown root:root -R $TargetDirectory

cd $TargetDirectory
wput $InfoInventory ftp://ftpl:ftpl123@$FtpServer
