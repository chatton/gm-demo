#!/bin/bash

set -eou pipefail

RLY_MNEMONIC="alley afraid soup fall idea toss can goose become valve initial strong forward bright dish figure check leopard decide warfare hub unusual join cart"

CHAIN_A_NAME="wasm-simapp-1"
CHAIN_B_NAME="gm"

CHAIN_A_KEY="rly-a"
CHAIN_B_KEY="gm-key"

mkdir -p ${HOME}/.relayer/config

# mount the config file into a different directory so the config directory is writable.
cp /home/relayer/docker/config.yaml ${HOME}/.relayer/config/config.yaml

echo "Using Config"
rly --home ${HOME}/.relayer config show

# relayer will have same address on both chains.
rly --home ${HOME}/.relayer keys restore ${CHAIN_A_NAME} ${CHAIN_A_KEY} "${RLY_MNEMONIC}" || true
rly --home ${HOME}/.relayer keys restore ${CHAIN_B_NAME} ${CHAIN_B_KEY} "${RLY_MNEMONIC}" || true

rly q balance ${CHAIN_A_NAME}
rly q balance ${CHAIN_B_NAME}

rly tx link rollkit-path --src-wasm-code-id ddc292a095aa9b8625d5d7ebdd3a9c2301bda10a489385d560ecd3f7846fbb39

rly start
