#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

num_chains=$(yq -r ".chains | length" $VALUES_FILE)

function stop_port_forward() {
  echo "Trying to stop all port-forward, if any...."
  PIDS=$(ps -ef | grep -i -e 'kubectl port-forward' | grep -v 'grep' | cat | awk '{print $2}') || true
  for p in $PIDS; do
    kill -15 $p
  done
}

# Default values
CHAIN_RPC_PORT=26657
CHAIN_LCD_PORT=1317
CHAIN_EXPOSER_PORT=8081
EXPLORER_LCD_PORT=8080
REGISTRY_LCD_PORT=8080
REGISTRY_GRPC_PORT=9090

stop_port_forward

echo "Port forwarding for config ${VALUES_FILE}"
echo "Port forwarding all chains"
num_chains=$(yq -r ".chains | length - 1" ${VALUES_FILE})
if [[ $num_chains -lt 0 ]]; then
  echo "No chains to port-forward: num: $num_chains"
  exit 1
fi
for i in $(seq 0 $num_chains); do
  chain=$(yq -r ".chains[$i].name" ${VALUES_FILE} )
  localrpc=$(yq -r ".chains[$i].ports.rpc" ${VALUES_FILE} )
  locallcd=$(yq -r ".chains[$i].ports.rest" ${VALUES_FILE} )
  localexp=$(yq -r ".chains[$i].ports.exposer" ${VALUES_FILE})
  [[ "$localrpc" != "null" ]] && kubectl port-forward pods/$chain-genesis-0 $localrpc:$CHAIN_RPC_PORT --namespace $NAMESPACE > /dev/null 2>&1 &
  [[ "$locallcd" != "null" ]] && kubectl port-forward pods/$chain-genesis-0 $locallcd:$CHAIN_LCD_PORT --namespace $NAMESPACE > /dev/null 2>&1 &
  [[ "$localexp" != "null" ]] && kubectl port-forward pods/$chain-genesis-0 $localexp:$CHAIN_EXPOSER_PORT --namespace $NAMESPACE > /dev/null 2>&1 &
  sleep 1
  echo "chains: forwarded $chain lcd to http://localhost:$locallcd, rpc to http://localhost:$localrpc"
done

echo "Port forward services"

if [[ $(yq -r ".registry.enabled" $VALUES_FILE) == "true" ]];
then
  kubectl port-forward service/registry 8081:$REGISTRY_LCD_PORT --namespace $NAMESPACE > /dev/null 2>&1 &
  kubectl port-forward service/registry 9091:$REGISTRY_GRPC_PORT --namespace $NAMESPACE > /dev/null 2>&1 &
  sleep 1
  echo "registry: forwarded registry lcd to grpc http://localhost:8081, to http://localhost:9091"
fi

if [[ $(yq -r ".explorer.enabled" $VALUES_FILE) == "true" ]];
then
  kubectl port-forward service/explorer 8080:$EXPLORER_LCD_PORT --namespace $NAMESPACE > /dev/null 2>&1 &
  sleep 1
  echo "Open the explorer to get started.... http://localhost:8080"
fi
