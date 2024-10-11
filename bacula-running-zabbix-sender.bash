#!/bin/bash

# Importa o arquivo de configuração
source /opt/bacula/etc/bacula-zabbix.conf

# Nome do host do Bacula no Zabbix
baculaHost="bacula-fd"

# Executa o comando 'status dir' via bconsole e captura a saída
output=$(echo "status dir" | bconsole)

# Conta o número de jobs que estão rodando (status Running)
running_jobs=$(echo "$output" | grep -c "is running")

# Captura o horário atual (hora em formato de 24h)
current_hour=$(date +"%-H")

# Sempre envia o número de jobs rodando para o Zabbix
$zabbixSender -z $zabbixServer -c $zabbixAgentConfig -s "$baculaHost" -k "bacula.running.jobs" -o "$running_jobs"

# Verifica se o horário está entre 9h e 13h (inclusive) e se há mais de 1 job rodando
if [[ $current_hour -ge 9 && $current_hour -le 11 && $running_jobs -ge 1 ]]; then
    # Envia o alerta para o Zabbix
    $zabbixSender -z $zabbixServer -c $zabbixAgentConfig -s "$baculaHost" -k "bacula.running.jobs.alert" -o "$running_jobs"
fi
