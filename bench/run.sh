#!/bin/sh

set -o xtrace

NODE="--node $RPC"
TXFLAG="$NODE --chain-id $CHAIN_ID --gas-prices 0.001ucosm gas auto --gas-adjustment 1.3"

wasmd init localnet --chain-id ${CHAIN_ID} --home ${APP_HOME}
sed -i -r 's/minimum-gas-prices = ""/minimum-gas-prices = "0.01ucosm"/' ${APP_HOME}/config/app.toml

KEYRING="--keyring-backend test --keyring-dir /.wasmd_keys"

MAIN_ADDR=$(wasmd keys add main $KEYRING --output json | jq '.address' -r)
echo $MAIN_ADDR
VALIDATOR_ADDR=$(wasmd keys add validator $KEYRING --output json | jq '.address' -r)
echo $VALIDATOR_ADDR

wasmd add-genesis-account $(wasmd keys show -a main $KEYRING) 10000000000ucosm,10000000000stake --home $APP_HOME
wasmd add-genesis-account $(wasmd keys show -a validator $KEYRING) 10000000000ucosm,10000000000stake --home $APP_HOME

wasmd gentx validator 1000000000stake --home $APP_HOME --chain-id $CHAIN_ID $KEYRING

wasmd collect-gentxs --home $APP_HOME
wasmd validate-genesis --home $APP_HOME

wasmd start --home $APP_HOME &
netstat -a
#wasmd query account $MAIN_ADDR --home $APP_HOME --chain-id $CHAIN_ID $NODE -o json
