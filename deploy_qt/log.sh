#!/bin/bash

#BINARYInstallApp=$BINARYInstallApp' '$DockerAppParam
#BINARYInstallApp=$BINARYInstallApp' '$DockerAppPort
# SCRIPT DE LOGS
#IP="127.0.0.1"
##IP=`ifconfig | perl -nle 's/dr:(\S+)/print $1/e' | grep -v '127.0.0.1' | grep -v '172.*' | grep -v '192.168.122.*'`
#LOG="IP: $IP - usuario: $(whoami) - data/hora: $(date +"%Y%m%d/%H%M%S")"
#LogsDIR="/usr/local/appversion/release/$BINARYEnv/$BINARYApp/logs"
#LogFilePath="$LogsDIR/$BINARYApp_logs_$(date +'%Y%m%d').log"
#CommandWriteLog="echo '$LOG' >> $LogFilePath"
#
### verifica se pasta de logs não existe.
#if ! ssh $BINARYSERVERUSER@$BINARYSERVER stat $LogsDIR \> /dev/null 2\>\&1
#then
#    # cria a pasta de logs
#	ssh $BINARYSERVERUSER@$BINARYSERVER eval "mkdir $LogsDIR"
#
#fi