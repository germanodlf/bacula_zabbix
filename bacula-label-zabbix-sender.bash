#!/bin/bash

# Import configuration file
source /opt/bacula/etc/bacula-zabbix.conf

# Bacula hostname on Zabbix
baculaHost="bacula-fd"

# Executa o comando 'status dir' via bconsole e captura a saída
output=$(echo "status dir" | bconsole)

# Conta o número de jobs que estão aguardando por mídia (label)
label_jobs=$(echo "$output" | grep -c "waiting for media")

# Envia o valor para o Zabbix via zabbix_sender
$zabbixSender -z $zabbixServer -c $zabbixAgentConfig -s "$baculaHost" -k "bacula.label.jobs" -o "$label_jobs"
