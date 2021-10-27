# syntax=docker/dockerfile:1

from cosmwasm/wasmd:v0.20.0

run apk add jq
run apk add net-tools

expose 26656
expose 26657

env APP_HOME="/.wasmd"
env RPC="http://localhost:26656"
env CHAIN_ID="cw-bench-localnet"

copy run.sh /
cmd /run.sh
