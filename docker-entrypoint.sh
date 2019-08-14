#!/bin/bash
set -e

set_config() {
    key="$1"
    value="$2"
    if grep -q "$key" "$config_tmp"; then
      sed_escaped_value="$(echo "$value" | sed 's/[\/&]/\\&/g')"
      sed -ri "s/^($key)[ ]*=.*$/\1=$sed_escaped_value/" "$config_tmp"
    else
      echo $'\r'"$key=$value" >> "$config_tmp"
    fi
}

init_config() {
  config_tmp="$(mktemp)"
  cat $(pwd)/config > "$config_tmp"

  set_config API_URL $API_URL
  set_config PUB_KEY $PUB_KEY
  set_config SET_OFF_TX $SET_OFF_TX
  set_config MISSED_BLOCKS $MISSED_BLOCKS
  set_config SLEEP_TIME_MS $SLEEP_TIME_MS

  cat "$config_tmp" > $(pwd)/config
  rm "$config_tmp"
}

if [ "$1" = 'start' ]; then
  init_config
  echo "minter guard started!"
  exec python3 /usr/local/lib/python3.6/site-packages/minterguard/guard.py --config=$(pwd)/config
fi

if [ "$1" = 'txgenerator' ]; then
  init_config
  echo "txgenerator is starting..."
  exec python3 /usr/local/lib/python3.6/site-packages/minterguard/txgenerator.py $(pwd)/config off
fi

exec "$@"
