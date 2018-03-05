#!/bin/bash

readonly VAGRANT_FILE="../Vagrantfile"
readonly HTML_OUT="list_socat.html"
readonly REMOTE_IP_LIST="$(grep -o 'ip:.*' "$VAGRANT_FILE" |  cut -d \" -f 2 | tr '\n' ' ')"
readonly REMOTE_HOST_LIST=($(grep -o 'hostname.*' "$VAGRANT_FILE" | cut -d \" -f 2 | tr '\n' ' '))
readonly REMOTE_PORT_SC=8384
readonly REMOTE_PORT_WWW=8000
readonly START_PORT=8800
readonly MY_IP="$(hostname -I | cut -f 1 -d ' ')"


echo '<!DOCTYPE html>
<html lang="en-US">
<head>
<title>Syncthing workshop</title>' > "$HTML_OUT"

port=$START_PORT; i=0
for ip in $REMOTE_IP_LIST; do
  port=$((port+1))
  echo "<a href=\"http://$MY_IP:$port\">${REMOTE_HOST_LIST[$i]} (Syncthing)</a>" >> "$HTML_OUT"
  echo "<br>" >> "$HTML_OUT"
  socat -d TCP4-LISTEN:"$port",fork,range=10.0.0.0/8,reuseaddr TCP4:"$ip":"$REMOTE_PORT_SC" &

  port=$((port+1))
  echo "<a href=\"http://$MY_IP:$port\">${REMOTE_HOST_LIST[$i]} (File browser)</a>" >> "$HTML_OUT"
  echo "<br>" >> "$HTML_OUT"
  socat -d TCP4-LISTEN:"$port",fork,range=10.0.0.0/8,reuseaddr TCP4:"$ip":"$REMOTE_PORT_WWW" &

  echo "<br>" >> "$HTML_OUT"
  i=$((i+1))
done

socat TCP-LISTEN:"$START_PORT",crlf,reuseaddr,fork SYSTEM:"echo HTTP/1.0 200; echo Content-Type\: text/html; echo; cat $HTML_OUT "

