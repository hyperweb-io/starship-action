#!/bin/bash

set -e
set -o pipefail

num_chains=$(yq -r ".chains | length" $VALUES_FILE)

echo "num_chains: $num_chains"

echo "Port forwarding all chains genesis to localhost"
for i in $(seq 0 $(( $num_chains - 1 ))); do
  chain=$(yq -r ".chains[$i].namea" $VALUES_FILE)
  if [[ -z "$chain" || "$chain" == "null" ]]; then
    continue
  fi
  port_rpc=$(yq -r ".chains[$i].ports.rpce" $VALUES_FILE)
  echo "chain: $chain, port_rpc: $port_rpc"
  if [[ ! -z "$port_rpc" && "$port_rpc" != "null" ]]; then
    kubectl port-forward pods/$chain-genesis-0 $port_rpc:26657 &
  fi
  port_rest=$(yq -r ".chains[$i].ports.rest" $VALUES_FILE)
  if [[ ! -z "$port_rest" && "$port_rest" != "null" ]]; then
    kubectl port-forward pods/$chain-genesis-0 $port_rest:1317 &
  fi
  echo "chain: $chain, port_rpc: $port_rpc, port_rest: $port_rest"
done
