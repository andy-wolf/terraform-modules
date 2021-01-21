#!/bin/bash

# Exit if any of the intermediate steps fail
set -e

function check_deps() {
  test -f $(which jq) || error_exit "jq command not detected in path, please install it"
  test -f $(which curl) || error_exit "curl command not detected in path, please install it"
  test -f $(which echo) || error_exit "echo command not detected in path, please install it"
  test -f $(which grep) || error_exit "grep command not detected in path, please install it"
}

function parse_input() {
  eval "$(jq -r '@sh "export IPADDR=\(.IPADDR) REGION=\(.REGION)"')"
  if [[ -z "${IPADDR}" ]]; then export IPADDR=none; fi
  if [[ -z "${REGION}" ]]; then export REGION=none; fi


  #local ip_address=$1
  #local activation_region=$2

  if [[ -z "$IPADDR" || -z "$REGION" ]]; then
    echo "Usage: get-activation-key ip_address activation_region"
    return 1
  fi
}

function return_activation_key() {

  if redirect_url=$(curl -f -s -S -w '%{redirect_url}' "http://$IPADDR/?activationRegion=$REGION"); then
    activation_key_param=$(echo "$redirect_url" | grep -oE 'activationKey=[A-Z0-9-]+')
  else
    return 1
  fi

  KEY=$(echo "$activation_key_param" | cut -f2 -d=)

  jq -n \
  --arg key "$KEY" \
  '{"key":$key}'
}


check_deps && \
parse_input && \
sleep 10 && \
return_activation_key