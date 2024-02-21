#!/bin/bash

set -eou pipefail

CHAIN_ID="wasmsimapp-1"
VAL_MNEMONIC_1="clock post desk civil pottery foster expand merit dash seminar song memory figure uniform spice circle try happy obvious trash crime hybrid hood cushion"
WALLET_MNEMONIC_1="banner spread envelope side kite person disagree path silver will brother under couch edit food venture squirrel civil budget number acquire point work mass"
RLY_MNEMONIC_1="alley afraid soup fall idea toss can goose become valve initial strong forward bright dish figure check leopard decide warfare hub unusual join cart"


function run_cmd(){
    docker run -v $HOME:/root ibc-go-wasm-simd:latest ${1}
}

echo "Initializing ${CHAIN_ID}..."

run_cmd "init test --chain-id=$CHAIN_ID"

echo "Adding genesis accounts..."
docker run -v $HOME:/root --entrypoint="" ibc-go-wasm-simd:latest /bin/sh -c "echo ${VAL_MNEMONIC_1} | simd keys add val1 --recover --keyring-backend=test"
docker run -v $HOME:/root --entrypoint="" ibc-go-wasm-simd:latest /bin/sh -c "echo ${WALLET_MNEMONIC_1} | simd keys add wallet1 --recover --keyring-backend=test"
docker run -v $HOME:/root --entrypoint="" ibc-go-wasm-simd:latest /bin/sh -c "echo ${RLY_MNEMONIC_1} | simd keys add rly1 --recover --keyring-backend=test"

docker run -v $HOME:/root ibc-go-wasm-simd:latest genesis add-genesis-account "$(run_cmd "keys show val1 --keyring-backend test -a")" 100000000000stake
docker run -v $HOME:/root ibc-go-wasm-simd:latest genesis add-genesis-account "$(run_cmd "keys show wallet1 --keyring-backend test -a")" 100000000000stake
docker run -v $HOME:/root ibc-go-wasm-simd:latest genesis add-genesis-account "$(run_cmd "keys show rly1 --keyring-backend test -a")" 100000000000stake

echo "Creating and collecting gentx..."
run_cmd "genesis gentx val1 100000000000stake --keyring-backend test --chain-id=$CHAIN_ID"
run_cmd "genesis collect-gentxs"

docker run -v $HOME:/root -d ibc-go-wasm-simd:latest start --rpc.laddr tcp://127.0.0.1:46657 --grpc.address 127.0.0.1:10290