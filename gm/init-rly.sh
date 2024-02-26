#!/bin/sh


RLY_MNEMONIC="alley afraid soup fall idea toss can goose become valve initial strong forward bright dish figure check leopard decide warfare hub unusual join cart"

CHAIN_A_NAME="wasm-simapp-1"
CHAIN_B_NAME="wasm-simapp-2"

CHAIN_A_KEY="wasm-1"
CHAIN_B_KEY="wasm-12"




rly keys restore ${CHAIN_A_NAME} ${CHAIN_A_KEY} "${RLY_MNEMONIC}"
rly keys restore ${CHAIN_B_NAME} ${CHAIN_B_KEY} "${RLY_MNEMONIC}"
