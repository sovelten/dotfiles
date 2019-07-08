!#/bin/sh
echo $1 $2
watch -g nu ser curl GET $1 $2 /api/version && notify-send "$1 WAS DEPLOYED"
