# syntax=docker/dockerfile:1

from cosmwasm/wasmd:v0.20.0

run apk add bash

env APP_HOME="/.wasmd"
env RPC="http://localhost:26657"
env CHAIN_ID="cw-bench-localnet"

run wasmd init localnet --chain-id ${CHAIN_ID} --home ${APP_HOME}
run sed -i -r 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucosm"/' ${APP_HOME}/config/app.toml

env KEYRING="--keyring-backend test --keyring-dir /.wasmd_keys"
run wasmd keys add main $KEYRING

run wasmd keys add validator $KEYRING

run wasmd add-genesis-account $(wasmd keys show -a main $KEYRING) 10000000000ucosm,10000000000stake --home ${APP_HOME}
run wasmd add-genesis-account $(wasmd keys show -a validator $KEYRING) 10000000000ucosm,10000000000stake --home ${APP_HOME}

run wasmd gentx validator 1000000000stake --home ${APP_HOME} --chain-id ${CHAIN_ID} $KEYRING

run wasmd collect-gentxs --home ${APP_HOME}
run wasmd validate-genesis --home ${APP_HOME}

cmd wasmd start --home ${APP_HOME}
