#!/bin/ash
hash="03fed5b990fbc2d64de9085ef9c66d24586b9380" # lolomgwtf
lolnode=/tmp/.rofl



killenv(){
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
        set authtoken="true"
        while true;do
        if $authtoken;then
          printf '$ '
          read cmd
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