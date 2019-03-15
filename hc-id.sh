#!/bin/bash 

myusername="vmo"
mypassword="AIue6300"
date=`date +%m%d%Y`

export myusername
export mypassword
export date

ssh_bns()
{

expect <<EOD

if { "$ip" eq "10.78.70.58"  || "$ip" eq "10.78.70.62" } {
  spawn ssh -t $myusername@$ip "sudo awk -F: '{if (\\\$2 == \"\*\" || \\\$2 ~ /^\!\!/ ) print \\\$1,\\\$2,strftime(\"\%Y\%m\%d\",86400*\\\$3),\\\$4,\\\$5,\\\$6,\\\$7; else print \\\$1,\" \"strftime(\"\%Y\%m\%d\",86400*\\\$3),\\\$4,\\\$5,\\\$6,\\\$7}' /etc/shadow | sort "
} else {
  spawn ssh -t $myusername@$ip "sudo passwd -as | sort"
}




#expect "Are you sure you want to continue connecting (yes/no)?"
#send "yes"
#expect "*assword: "
#send "$mypassword\r";
#wait
expect "*:" 
send "$mypassword\r";
#wait
expect eof
EOD
}


scp_copytojumpbox()
{
expect <<EOD
spawn scp -p $myusername@$ip:/tmp/hcresult-id-$ip /home/vmo/healthcheck/hc-id/
#expect "Are you sure you want to continue connecting (yes/no)?"
#send "yes\r"
expect "*assword: "
send  "$mypassword\r";
#wait
expect eof
EOD
}


while read -u 3 ip
  do
  export ip
#  scp_copytoserver
  ssh_bns > /home/vmo/healthcheck/hc-id/hcresult-id-$date-$ip
#  scp_copytojumpbox
done 3<ip-list

