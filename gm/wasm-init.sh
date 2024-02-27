#!/bin/sh

VAL_MNEMONIC_1="clock post desk civil pottery foster expand merit dash seminar song memory figure uniform spice circle try happy obvious trash crime hybrid hood cushion"
WALLET_MNEMONIC_1="banner spread envelope side kite person disagree path silver will brother under couch edit food venture squirrel civil budget number acquire point work mass"
RLY_MNEMONIC_1="alley afraid soup fall idea toss can goose become valve initial strong forward bright dish figure check leopard decide warfare hub unusual join cart"

# clear existing data
rm -rf /root/.simapp

echo "Initializing ${CHAIN_ID}..."

simd init test --chain-id=$CHAIN_ID

echo "Adding genesis accounts..."
echo ${VAL_MNEMONIC_1} | simd keys add val1 --recover --keyring-backend=test
echo ${WALLET_MNEMONIC_1} | simd keys add wallet1 --recover --keyring-backend=test
echo ${RLY_MNEMONIC_1} | simd keys add rly1 --recover --keyring-backend=test

simd genesis add-genesis-account "$(simd keys show val1 --keyring-backend test -a)" 100000000000stake
simd genesis add-genesis-account "$(simd keys show wallet1 --keyring-backend test -a)" 100000000000stake
simd genesis add-genesis-account "$(simd keys show rly1 --keyring-backend test -a)" 100000000000stake

echo "Creating and collecting gentx..."
simd genesis gentx val1 100000000000stake --keyring-backend test --chain-id=$CHAIN_ID
simd genesis collect-gentxs

genesis_contents=$(cat /root/.simapp/config/genesis.json)
python ./update-genesis.py "${genesis_contents}" /root/.simapp/config/genesis.json  /ics07_tendermint_cw.wasm

echo "Final genesis.json" && cat ~/.simapp/config/genesis.json

simd start --rpc.laddr tcp://localhost:46657 --rpc.pprof_laddr localhost:6060 --grpc.address localhost:10290 --p2p.laddr "0.0.0.0:56656"