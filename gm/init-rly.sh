#!/bin/sh

RLY_MNEMONIC="alley afraid soup fall idea toss can goose become valve initial strong forward bright dish figure check leopard decide warfare hub unusual join cart"

CHAIN_A_NAME="wasm-simapp-1"
CHAIN_B_NAME="wasm-simapp-2"

CHAIN_A_KEY="rly-a"
CHAIN_B_KEY="rly-b"

echo "Using Config"
rly --home /root/.relayer config show

# relayer will have same address on both chains.
rly --home /root/.relayer keys restore ${CHAIN_A_NAME} ${CHAIN_A_KEY} "${RLY_MNEMONIC}"
rly --home /root/.relayer keys restore ${CHAIN_B_NAME} ${CHAIN_B_KEY} "${RLY_MNEMONIC}"

# use the created key
rly keys use ${CHAIN_A_NAME} ${CHAIN_A_KEY}
rly keys use ${CHAIN_B_NAME} ${CHAIN_B_KEY}

rly q balance ${CHAIN_A_NAME}
rly q balance ${CHAIN_B_NAME}

rly transact client wasm-simapp-1 wasm-simapp-2 demo-path --src-wasm-code-id ddc292a095aa9b8625d5d7ebdd3a9c2301bda10a489385d560ecd3f7846fbb39